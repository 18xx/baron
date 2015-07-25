RSpec.describe Baron::Certificate do
  subject { described_class.new(company, portion) }
  let(:company) do
    Baron::MajorCompany.new('LNWR', nil)
  end
  let(:portion) { BigDecimal.new '0.1' }

  describe '#company' do
    it 'returns the company' do
      expect(subject.company).to eq company
    end
  end

  describe 'portion' do
    it 'returns the portion of this certificate' do
      expect(subject.portion).to eq portion
    end
  end
end
