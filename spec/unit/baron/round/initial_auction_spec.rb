RSpec.describe Baron::Round::InitialAuction do
  let(:auction_round) { described_class.new game }

  let(:player1) { Baron::Player.new '1' }
  let(:player2) { Baron::Player.new '2' }
  let(:player3) { Baron::Player.new '3' }
  let(:players) do
    [player1, player2, player3]
  end

  let(:game) { Baron::Game.new rules, players }
  let(:rules) { Baron::Rules.new '1860' }

  describe 'initialization' do
    subject { auction_round }

    it 'makes the initial 4 private companies available' do
      expect { subject }.to change {
        game.initial_offering.certificates.select do |cert|
          cert.company.is_a? Baron::Company::PrivateCompany
        end.count
      }.from(0).to(4)
    end

    it 'makes the initial 2 major companies directors shares' do
      expect { subject }.to change {
        game.initial_offering.certificates.select do |cert|
          cert.company.is_a? Baron::Company::MajorCompany
        end.count
      }.from(0).to(2)
    end

    it 'makes the initial 2 major companies directors shares' do
      subject
      certs = game.initial_offering.certificates.select do |cert|
        cert.company.is_a? Baron::Company::MajorCompany
      end
      expect(certs.all?(&:director?)).to be true
    end
  end

  describe '#game' do
    subject { auction_round.game }

    it 'returns the game' do
      should be game
    end
  end

  describe '#current_operation' do
    subject { auction_round.current_operation }

    it 'returns a new WinnerChooseAuction' do
      expect(subject).to be_a Baron::Operation::WinnerChooseAuction
    end

    it 'assigns players to the auction round' do
      expect(subject.active_players).to eq players
    end

    it 'assigns the bank to the auction round' do
      expect(subject.bank).to be_a Baron::Bank
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
          expect(subject).to equal auction_round.current_operation
        end
      end

      context 'when the auction is done' do
        let(:done) { true }

        it 'returns a new auction' do
          expect(subject).to_not equal auction_round.current_operation
        end

        it 'has the player after the previous winner going first' do
          subject
          expect(auction_round.current_operation.active_players).to eq [
            player3,
            player1,
            player2
          ]
        end
      end
    end
  end

  describe '#over?' do
    subject { auction_round.over? }

    context 'when there are still certificates available' do
      it { should be false }
    end

    context 'when all auctions have finished' do
      before do
        auction_round
        # Have player 1 buy all the certificates
        Baron::Transaction.new(
          player1,
          game.initial_offering.certificates,
          game.initial_offering,
          []
        )
      end

      it { should be true }
    end
  end
end
