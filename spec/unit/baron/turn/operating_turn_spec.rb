RSpec.describe Baron::Turn::OperatingTurn do
  let(:turn) { described_class.new player, company }
  let(:company) { instance_double Baron::Company }
  let(:player) { instance_double Baron::Player }

  describe '#company' do
    subject { turn.company }
    it 'returns the company' do
      should be company
    end
  end

  describe '#player' do
    subject { turn.player }
    it 'returns the player of the company' do
      should be player
    end
  end

  describe '#done?' do
    subject { turn.done? }
    it { should be false }
  end
end
