RSpec.describe Baron::Company::PrivateCompany do
  subject do
    described_class.new('C&A', 'Camden & Amboy', face_value: 160, revenue: 25)
  end

  describe '#abbreviation' do
    it 'returns the company abbreviation' do
      expect(subject.abbreviation).to eq 'C&A'
    end
  end

  describe '#name' do
    it 'returns the company name' do
      expect(subject.name).to eq 'Camden & Amboy'
    end
  end

  describe '#face_value' do
    it 'returns the face value' do
      expect(subject.face_value).to eq 160
    end
  end

  describe '#revenue' do
    it 'returns per OR revenue' do
      expect(subject.revenue).to eq 25
    end
  end

  describe '#to_s' do
    it 'returns the company name' do
      expect(subject.to_s).to eq 'C&A'
    end
  end
end
