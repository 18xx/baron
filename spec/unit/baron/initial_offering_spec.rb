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
      before do
        initial_offering.set_par_price company, Baron::Money.new(75)
      end

      let(:company) do
        Baron::Company::MajorCompany.new(
          'THB', 'Toronto, Hamilton & Buffalo'
        )
      end

      context 'when the certificate is a directors share' do
        let(:portion) { BigDecimal.new('0.2') }

        it 'returns the double the par price' do
          should == Baron::Money.new(150)
        end
      end

      context 'when the certificate is a standard share' do
        let(:portion) { BigDecimal.new('0.1') }

        it 'returns the par price' do
          should == Baron::Money.new(75)
        end
      end
    end
  end

  describe 'par prices' do
    let(:company) do
      Baron::Company::MajorCompany.new('PRR', 'Pennsylvanid Railroad')
    end

    subject { initial_offering.get_par_price company }

    context 'when the par has not been set' do
      it { should be nil }
    end

    context 'when the par price has been set' do
      before { initial_offering.set_par_price company, Baron::Money.new(67) }

      it 'returns the par price' do
        should == Baron::Money.new(67)
      end

      it 'throws an error when trying to reset the par price' do
        expect { initial_offering.set_par_price company, Baron::Money.new(100) }
          .to raise_error(
            Baron::InitialOffering::ParPriceAlreadySet,
            'Attempted to reset par price for PRR'
          )
      end
    end
  end

  describe '#inspect' do
    subject { initial_offering.inspect }
    it 'returns a string representation of the object' do
      expect(subject).to eq(
        "#<Baron::InitialOffering:#{initial_offering.object_id}>"
      )
    end
  end
end
