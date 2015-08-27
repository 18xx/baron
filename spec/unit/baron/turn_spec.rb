RSpec.describe Baron::Turn do
  let(:turn) { Baron::Turn.new }

  describe '#perform' do
  end

  describe '#player' do
    subject { turn.player }
    it 'raises a not implemented error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end
