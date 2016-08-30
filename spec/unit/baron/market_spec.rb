# frozen_string_literal: true
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

  describe '#operating_order' do
    let(:cheap_company) { instance_double Baron::Company }
    let(:expensive_company) { instance_double Baron::Company }
    let(:mid_priced_company) { instance_double Baron::Company }

    before do
      market.add_company cheap_company, Baron::Money.new(68)
      market.add_company expensive_company, Baron::Money.new(100)
      market.add_company mid_priced_company, Baron::Money.new(82)
    end

    subject { market.operating_order }

    it 'operates the companies from most expensive to least expensive' do
      expect(subject).to eq(
        [
          expensive_company,
          mid_priced_company,
          cheap_company
        ]
      )
    end

    context 'when two companies are tied' do
      let(:other_cheap_company) { instance_double Baron::Company }

      before do
        market.add_company other_cheap_company, Baron::Money.new(68)
      end

      it 'operates them in the order that they were added as a tiebreak' do
        expect(subject).to eq(
          [
            expensive_company,
            mid_priced_company,
            cheap_company,
            other_cheap_company
          ]
        )
      end
    end
  end

  describe '#change_price' do
    before { market.add_company company, starting_price }
    subject { market.change_price company, steps }

    context 'when steps is positive' do
      let(:steps) { 4 }

      it 'increases the price' do
        expect { subject }.to change {
          market.price(company).amount
        }.from(90).to(110)
      end
    end

    context 'when steps is negative' do
      let(:steps) { -3 }

      it 'increases the price' do
        expect { subject }.to change {
          market.price(company).amount
        }.from(90).to(78)
      end
    end
  end
end
