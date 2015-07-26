RSpec.describe Baron::Transaction do
  let(:buyer) { double Baron::Player }
  let(:seller) { double Baron::Player }
  let(:buyer_items) { [object_double(Baron::Certificate)] }
  let(:seller_items) { [object_double(Baron::Certificate)] }

  subject { described_class.new(buyer, buyer_items, seller, seller_items) }

  describe '#buyer' do
    it 'returns the buyer' do
      expect(subject.buyer).to eq buyer
    end
  end

  describe '#buyer_items' do
    it 'returns the buyer items' do
      expect(subject.buyer_items).to eq buyer_items
    end
  end

  describe '#seller' do
    it 'returns the seller' do
      expect(subject.seller).to eq seller
    end
  end

  describe '#seller_items' do
    it 'returns the seller items' do
      expect(subject.seller_items).to eq seller_items
    end
  end

  describe '#debits' do
    specify do
      expect(subject.debits(buyer)).to eq(seller_items)
      expect(subject.debits(seller)).to eq(buyer_items)
    end

    context 'when shareholder is not a party to this transaction' do
      it 'raises an error' do
        expect { subject.debits(double) }.to raise_error(
          Baron::Transaction::InvalidPartyError
        )
      end
    end
  end

  describe '#credits' do
    specify do
      expect(subject.credits(buyer)).to eq(buyer_items)
      expect(subject.credits(seller)).to eq(seller_items)
    end

    context 'when shareholder is not a party to this transaction' do
      it 'raises an error' do
        expect { subject.debits(double) }.to raise_error(
          Baron::Transaction::InvalidPartyError
        )
      end
    end
  end
end
