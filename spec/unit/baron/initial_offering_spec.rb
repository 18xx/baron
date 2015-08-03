RSpec.describe Baron::InitialOffering do
  let(:initial_offering) { Baron::InitialOffering.new }
  let(:certificate) { Baron::Certificate.new(company, portion) }

  describe '#cost' do
    subject { initial_offering.cost certificate }
    context 'when the certificate is for a private company' do
      let(:company) do
        Baron::Company::PrivateCompany.new(
          'C&A',
          'Camden & Amboy',
          face_value: Baron::Money.new(160),
          revenue: Baron::Money.new(25)
        )
      end
      let(:portion) { BigDecimal.new('1') }

      it 'returns the face value' do
        should == Baron::Money.new(160)
      end
    end

    context 'when the certificate is for a major company' do
      context 'when the certificate is a directors share' do
      end

      context 'when the certificate is a standard share' do
      end
    end
  end
end
