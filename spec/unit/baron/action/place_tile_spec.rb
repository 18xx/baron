RSpec.describe Baron::Action::PlaceTile do
  let(:turn) { double }
  let(:tile) { double }
  let(:hex) { double }
  let(:orientation) { double }
  let(:action) do
    Baron::Action::PlaceTile.new(
      turn,
      tile,
      hex,
      orientation
    )
  end

  describe '#turn' do
    subject { action.turn }
    it 'returns the turn for this action' do
      should be turn
    end
  end

  describe '#tile' do
    subject { action.tile }
    it 'returns the tile for this action' do
      should be tile
    end
  end

  describe '#hex' do
    subject { action.hex }
    it 'returns the hex for this action' do
      should be hex
    end
  end

  describe '#orientation' do
    subject { action.orientation }
    it 'returns the orientation' do
      should be orientation
    end
  end
end
