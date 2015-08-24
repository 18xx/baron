RSpec.describe Baron::Market do
  let(:market) { described_class.new rules }
  let(:rules) { Baron::Rules.new('1860') }
  let(:company) { instance_double Baron::Company }
  let(:starting_price) { Baron::Money.new(90) }

  describe '#add_company' do
    subject { market.add_company company, starting_price }

    context 'when the starting price is a valid market value' do
      it 'adds the company to the market' do
        subject
        expect(market.price(company)).to eq Baron::Money.new(90)
      end
    end

    context 'when the starting price is not a valid market value' do
      let(:starting_price) { Baron::Money.new 91 }

      it 'raises an invalid starting price error' do
        expect { subject }.to raise_error(Baron::Market::InvalidStartingPrice)
      end
    end
  end
end
