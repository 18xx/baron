RSpec.describe Baron::Company::MajorCompany do
  subject { described_class.new(abbreviation, name) }
  let(:abbreviation) { 'LNWR' }
  let(:name) { 'London and North Western Railway' }

  describe '#abbrevation' do
    it 'returns the company abbreviation' do
      expect(subject.abbreviation).to eq 'LNWR'
    end
  end

  describe '#name' do
    it 'returns the company name' do
      expect(subject.name).to eq 'London and North Western Railway'
    end
  end

  describe '#to_s' do
    it 'returns the company abbreviation' do
      expect(subject.to_s).to eq 'LNWR'
    end
  end
end
