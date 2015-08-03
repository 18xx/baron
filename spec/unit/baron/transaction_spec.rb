RSpec.describe Baron::Transaction do
  let(:buyer) { instance_double Baron::Player, add_transaction: nil }
  let(:seller) { instance_double Baron::Player, add_transaction: nil }
  let(:buyer_items) do
    [
      buyer_certificate,
      double
    ]
  end
  let(:seller_items) do
    [
      seller_certificate,
      double
    ]
  end

  let(:buyer_certificate) { Baron::Certificate.new(double, double) }
  let(:seller_certificate) { Baron::Certificate.new(double, double) }

  let(:transaction) do
    described_class.new(buyer, buyer_items, seller, seller_items)
  end

  subject { transaction }

  describe 'initialization' do
    let(:buyer) { spy('buyer') }
    let(:seller) { spy('seller') }

    context 'when seller is nil' do
      let(:seller) { nil }

      it 'does not assign the transaction' do
        subject
      end
    end

    it 'assigns the transaction to the buyer' do
      subject
      expect(buyer).to have_received(:add_transaction).with(subject)
    end

    it 'assigns the transaction to the seller' do
      subject
      expect(seller).to have_received(:add_transaction).with(subject)
    end
  end

  describe 'validaton' do
    context 'when buyer_items is nil' do
      let(:buyer_items) { nil }

      it 'does not raise an error' do
        expect(subject.buyer_items).to be_nil
      end
    end

    context 'when buyer_items is not an array' do
      let(:buyer_items) { double }

      it 'raises an invalid items error' do
        expect { subject }.to raise_error(Baron::Transaction::InvalidItemsError)
      end
    end

    context 'when seller_items is nil' do
      let(:seller_items) { nil }

      it 'does not raise an error' do
        expect(subject.seller_items).to be_nil
      end
    end

    context 'when seller_items is not an array' do
      let(:seller_items) { double }

      it 'raises an invalid items error' do
        expect { subject }.to raise_error(Baron::Transaction::InvalidItemsError)
      end
    end
  end

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

  describe '#incoming_certificates' do
    subject { transaction.incoming_certificates shareholder }

    context 'with the buyer' do
      let(:shareholder) { buyer }

      it 'returns the buyer items' do
        expect(subject).to match_array([buyer_certificate])
      end
    end

    context 'with the seller' do
      let(:shareholder) { seller }

      it 'returns the seller items' do
        expect(subject).to match_array([seller_certificate])
      end
    end
  end

  describe '#outgoing_certificates' do
    subject { transaction.outgoing_certificates shareholder }

    context 'with the buyer' do
      let(:shareholder) { buyer }

      it 'returns the seller items' do
        expect(subject).to match_array([seller_certificate])
      end
    end

    context 'with the seller' do
      let(:shareholder) { seller }

      it 'returns the buyer items' do
        expect(subject).to match_array([buyer_certificate])
      end
    end
  end
end
