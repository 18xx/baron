RSpec.describe Baron::Transaction do
  let(:buyer) { Baron::Player.new 'buyer' }
  let(:seller) { Baron::Player.new 'seller' }
  let(:buyer_items) do
    [
      buyer_certificate,
      Baron::Money.new(10)
    ]
  end
  let(:seller_items) do
    [
      seller_certificate,
      Baron::Money.new(20)
    ]
  end

  let(:buyer_certificate) { Baron::Certificate.new(double, double) }
  let(:seller_certificate) { Baron::Certificate.new(double, double) }

  let(:transaction) do
    described_class.new(buyer, buyer_items, seller, seller_items)
  end

  before do
    buyer_certificate.owner = seller
    seller_certificate.owner = buyer
  end

  subject { transaction }

  describe 'initialization' do
    describe 'add transaction' do
      context 'when seller is nil' do
        let(:seller) { nil }

        it 'does not assign the transaction' do
          subject
        end
      end

      let(:buyer) { spy('buyer') }
      let(:seller) { spy('seller') }

      it 'assigns the transaction to the buyer' do
        subject
        expect(buyer).to have_received(:add_transaction).with(subject)
      end

      it 'assigns the transaction to the seller' do
        subject
        expect(seller).to have_received(:add_transaction).with(subject)
      end
    end

    describe 'ownership' do
      describe 'buyer' do
        it 'gains buyer items' do
          expect(buyer_certificate.owner).to be seller
          subject
          expect(buyer_certificate.owner).to be buyer
        end
      end

      describe 'seller' do
        it 'gains seller items' do
          expect(seller_certificate.owner).to be buyer
          subject
          expect(seller_certificate.owner).to be seller
        end
      end
    end
  end

  describe 'validaton' do
    context 'when buyer_items is not an array' do
      let(:buyer_items) { double }

      it 'raises an invalid items error' do
        expect { subject }.to raise_error(
          Baron::Transaction::InvalidItemsError
        )
      end
    end

    context 'when buyer_items contains a non-transferrable item' do
      let(:buyer_items) { [''] }

      it 'raises an non tranferrable error' do
        expect { subject }.to raise_error(
          Baron::Transaction::NonTransferrableError
        )
      end
    end

    describe 'seller_items' do
      context 'when seller_items is not an array' do
        let(:seller_items) { double }

        it 'raises an invalid items error' do
          expect { subject }.to raise_error(
            Baron::Transaction::InvalidItemsError
          )
        end
      end

      context 'when seller_items contains a non-transferrable item' do
        let(:seller_items) { [''] }

        it 'raises an non tranferrable error' do
          expect { subject }.to raise_error(
            Baron::Transaction::NonTransferrableError
          )
        end
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
