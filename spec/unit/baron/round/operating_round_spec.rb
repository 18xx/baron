RSpec.describe Baron::Round::OperatingRound do
  let(:game) { double }
  let(:round) { Baron::Round::OperatingRound.new game }

  describe '#game' do
    subject { round.game }
    it 'returns the game' do
      should be game
    end
  end
end
