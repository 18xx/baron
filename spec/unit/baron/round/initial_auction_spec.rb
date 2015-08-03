RSpec.describe Baron::Round::InitialAuction do
  let(:auction) { described_class.new game }
  let(:bank) { double }

  let(:player1) { instance_double Baron::Player }
  let(:player2) { instance_double Baron::Player }
  let(:player3) { instance_double Baron::Player }
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

    it 'returns the same one when called successive times' do
      expect(subject).to equal auction.current_operation
    end
  end
end
