RSpec.describe Baron::Round::StockRound do
  let(:stock_round) { described_class.new game }

  let(:player1) { Baron::Player.new '1' }
  let(:player2) { Baron::Player.new '2' }
  let(:player3) { Baron::Player.new '3' }
  let(:players) do
    [player1, player2, player3]
  end

  let(:game) { Baron::Game.new rules, players }
  let(:rules) { Baron::Rules.new '1860' }

  describe '#game' do
    subject { stock_round.game }

    it 'returns the game' do
      should be game
    end
  end
end
