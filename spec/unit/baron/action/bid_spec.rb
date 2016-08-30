# frozen_string_literal: true
RSpec.describe Baron::Action::Bid do
  let(:player) { object_double Baron::Player }
  let(:amount) { Baron::Money.new 10 }

  let(:bid) { described_class.new player, amount }

  describe 'validation' do
    context 'when the bid is greater than zero' do
      it 'does not raise an error' do
        expect { bid }.to_not raise_error
      end
    end

    context 'when the bid is zero' do
      let(:amount) { 0 }
      it 'does not raise an error' do
        expect { bid }.to_not raise_error
      end
    end

    context 'when the bid is not a multiple of 5' do
      let(:amount) { 1 }

      it 'raises an error' do
        expect { bid }.to raise_error(
          Baron::Action::IllegalBidAmount,
          'Amount must be divisible by 5'
        )
      end
    end

    context 'when the bid is negative' do
      let(:amount) { -1 }

      it 'raises an error' do
        expect { bid }.to raise_error(
          Baron::Action::IllegalBidAmount,
          'Amount cannot be negative'
        )
      end
    end
  end

  describe '#player' do
    it 'returns the player' do
      expect(bid.player).to eq(player)
    end
  end

  describe '#amount' do
    it 'return the amount' do
      expect(bid.amount).to eq(amount)
    end
  end
end
