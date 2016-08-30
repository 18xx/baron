# frozen_string_literal: true
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

  describe '#controlling?' do
    subject { certificate.controlling? }

    context 'when this is a 100% share' do
      let(:portion) { BigDecimal.new '1' }

      it { should be true }
    end

    context 'when this is a 20% share' do
      let(:portion) { BigDecimal.new '0.2' }

      it { should be true }
    end

    context 'when this is a 10% share' do
      it { should be false }
    end
  end

  describe '#director?' do
    subject { certificate.director? }

    context 'when this is a 100% share' do
      let(:portion) { BigDecimal.new '1' }

      it { should be false }
    end

    context 'when this is a 20% share' do
      let(:portion) { BigDecimal.new '0.2' }

      it { should be true }
    end

    context 'when this is a 10% share' do
      it { should be false }
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

  describe '#inspect' do
    subject { certificate.inspect }

    it 'returns a string representation of the object' do
      should == "#<Baron::Certificiate:#{certificate.object_id} LNWR @ 0.1>"
    end
  end

  describe '#market_cost' do
    subject { certificate.market_cost market }

    let(:market) { instance_double Baron::Market }
    let(:value) { Baron::Money.new(100) }

    before do
      allow(market).to receive(:price).with(company).and_return(value)
    end

    context 'when the certificate is for 1 share' do
      it 'returns the market value of the company' do
        should eq Baron::Money.new(100)
      end
    end

    context 'when the certificate is for 2 shares' do
      let(:portion) { BigDecimal.new '0.2' }

      it 'returns the two times the market value of the company' do
        should eq Baron::Money.new(200)
      end
    end
  end
end
