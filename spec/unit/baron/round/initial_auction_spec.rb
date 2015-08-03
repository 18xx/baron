RSpec.describe Baron::Round::InitialAuction do
  let(:auction) { described_class.new game }
  let(:bank) { double }

  let(:player1) { instance_double Baron::Player, '1' }
  let(:player2) { instance_double Baron::Player, '2' }
  let(:player3) { instance_double Baron::Player, '3' }
  let(:players) do
    [player1, player2, player3]
  end

  let(:game) { instance_double Baron::Game, bank: bank, players: players }

  describe '#game' do
    subject { auction.game }

    it 'returns the game' do
      should equal game
    end
  end

  describe '#current_operation' do
    subject { auction.current_operation }

    it 'returns a new WinnerChooseAuction' do
      expect(subject).to be_a Baron::Operation::WinnerChooseAuction
    end

    it 'assigns players to the auction' do
      expect(subject.active_players).to eq players
    end

    it 'assigns the bank to the auction' do
      expect(subject.bank).to eq bank
    end

    context 'when called successive times' do
      before do
        allow_any_instance_of(
          Baron::Operation::WinnerChooseAuction
        ).to receive(:done?).and_return(false, done)
        allow_any_instance_of(
          Baron::Operation::WinnerChooseAuction
        ).to receive(:high_bidder).and_return(player2)
      end

      context 'when the auction is not done' do
        let(:done) { false }

        it 'returns the same one' do
          expect(subject).to equal auction.current_operation
        end
      end

      context 'when the auction is done' do
        let(:done) { true }

        it 'returns a new auction' do
          expect(subject).to_not equal auction.current_operation
        end

        it 'has the player after the previous winner going first' do
          subject
          expect(auction.current_operation.active_players).to eq [
            player3,
            player1,
            player2
          ]
        end
      end
    end
  end
end
