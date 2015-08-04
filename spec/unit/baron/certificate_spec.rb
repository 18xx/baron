RSpec.describe Baron::Certificate do
  let(:certificate) { described_class.new(company, portion) }
  let(:company) do
    Baron::Company::MajorCompany.new('LNWR', nil)
  end
  let(:portion) { BigDecimal.new '0.1' }

  subject { certificate }

  describe '#company' do
    it 'returns the company' do
      expect(subject.company).to eq company
    end
  end

  describe '#portion' do
    it 'returns the portion of this certificate' do
      expect(subject.portion).to eq portion
    end
  end

  describe '#num_shares' do
    subject { certificate.num_shares }

    context 'when this is a directors share' do
      let(:portion) { BigDecimal.new '0.2' }

      it { should == 2 }
    end

    context 'when this is a standard share' do
      it { should == 1 }
    end
  end
end
