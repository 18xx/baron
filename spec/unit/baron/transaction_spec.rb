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
end
