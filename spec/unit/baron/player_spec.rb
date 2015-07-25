RSpec.describe Baron::Player do
  subject { described_class.new(name) }
  let(:name) { 'Namine' }

  describe '#name' do
    it 'returns the players name' do
      expect(subject.name).to eq 'Namine'
    end
  end

  describe '#position' do
    before { subject.position = 4 }
    it 'returns the players position' do
      expect(subject.position).to eq(4)
    end
  end

  describe '#position=' do
    it 'assigns the players position' do
      expect { subject.position = 2 }.to(
        change { subject.position }.from(nil).to(2)
      )
    end
  end

  describe '#to_s' do
    it 'returns the players name' do
      expect(subject.to_s).to eq 'Namine'
    end
  end
end
