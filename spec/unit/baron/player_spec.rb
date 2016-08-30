# frozen_string_literal: true
RSpec.describe Baron::Player do
  subject { described_class.new(name) }
  let(:name) { 'Namine' }

  describe '#name' do
    it 'returns the players name' do
      expect(subject.name).to eq 'Namine'
    end
  end

  describe '#position' do
    pending
  end

  describe '#to_s' do
    it 'returns the players name' do
      expect(subject.to_s).to eq 'Namine'
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the object' do
      expect(subject.inspect).to eq(
        "#<Baron::Player:#{subject.object_id} Namine>"
      )
    end
  end
end
