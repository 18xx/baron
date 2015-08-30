RSpec.describe Baron::Action::RunTrains do
  let(:turn) { instance_double Baron::Turn, player: player }
  let(:hex) { double }
  let(:player) { instance_double Baron::Player, 'player' }
  let(:action) { described_class.new turn, 100, 10 }

  describe '#player' do
    subject { action.player }
    it 'returns the player for the turn' do
      should be player
    end
  end

  describe '#turn' do
    subject { action.turn }
    it 'returns the turn for this action' do
      should be turn
    end
  end

  describe '#amount' do
    subject { action.amount }
    it 'returns the amount for this action' do
      should eq 100
    end
  end

  describe '#corporate_bonus' do
    subject { action.corporate_bonus }
    it 'returns the corporate_bonus for this action' do
      should eq 10
    end
  end
end
