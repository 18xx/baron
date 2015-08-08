RSpec.describe Baron::Shareholder do
  # Shareholder shunt
  class MyShareholder
    include ::Baron::Shareholder
  end

  let(:a_certificate) do
    Baron::Certificate.new company, BigDecimal.new('0.1')
  end
  let(:company) { instance_double Baron::Company }

  let(:a) { MyShareholder.new }
  let(:a_credits) { [Baron::Money.new(10), a_certificate] }
  let(:a_debits) { [Baron::Money.new(50)] }
  let(:a_credits_2) { [Baron::Money.new(100)] }
  let(:a_debits_2) { [Baron::Money.new(25)] }
  let(:b) { MyShareholder.new }

  let!(:transactions) do
    [
      Baron::Transaction.new(a, a_credits, b, a_debits),
      Baron::Transaction.new(a, a_credits_2, b, a_debits_2)
    ]
  end

  describe '#balance' do
    subject { a.balance.amount }

    it 'is the sum of all credits minus debits' do
      should == 35
    end

    context 'when there are no debits' do
      let!(:transactions) do
        [
          Baron::Transaction.new(a, a_credits, nil, []),
          Baron::Transaction.new(a, a_credits_2, nil, [])
        ]
      end

      it 'is the sum of all credits' do
        should == 110
      end
    end
  end

  describe '#certificates' do
    let(:certificate) { Baron::Certificate.new company, BigDecimal.new('0.1') }
    subject { a.certificates }

    context 'when the shareholder has nothing' do
      let!(:transactions) { nil }
      it { should be_empty }
    end

    context 'when the shareholder has acquired something' do
      let!(:transactions) do
        [
          Baron::Transaction.new(a, [certificate], nil, [])
        ]
      end

      it 'includes those certificates' do
        expect(subject).to include certificate
      end
    end

    context 'when the shareholder has sold certificates' do
      let!(:transactions) do
        [
          Baron::Transaction.new(a, [certificate], nil, []),
          Baron::Transaction.new(a, [], nil, [certificate])
        ]
      end

      it 'does not include certificates they have sold' do
        should be_empty
      end
    end

    context 'when the shareholder, buys, sells, and buys the same cert' do
      let!(:transactions) do
        [
          Baron::Transaction.new(a, [certificate], nil, []),
          Baron::Transaction.new(a, [], nil, [certificate]),
          Baron::Transaction.new(a, [certificate], nil, [])
        ]
      end

      it 'includes that certificate' do
        expect(subject).to include certificate
      end
    end
  end
end
