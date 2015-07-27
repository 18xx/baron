RSpec.describe Baron::Game do
  subject { described_class.new(rules, players) }
  let(:rules) { object_double(Baron::Rules) }
  let(:players) { double }

  describe '#rules' do
    it 'returns the players in this game' do
      expect(subject.rules).to eq(rules)
    end
  end

  describe '#players' do
    it 'returns the players in this game' do
      expect(subject.players).to eq(players)
    end
  end
end
