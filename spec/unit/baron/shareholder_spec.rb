RSpec.describe Baron::Shareholder do
  # Shareholder shunt
  class MyShareholder
    include ::Baron::Shareholder
  end

  let(:a) { MyShareholder.new }
  let(:a_credits) { [Baron::Money.new(10), double(Baron::Certificate)] }
  let(:a_debits) { [Baron::Money.new(50)] }
  let(:a_credits_2) { [Baron::Money.new(100)] }
  let(:a_debits_2) { [Baron::Money.new(25)] }
  let(:b) { MyShareholder.new }

  let(:transactions) do
    [
      Baron::Transaction.new(a, a_credits, b, a_debits),
      Baron::Transaction.new(a, a_credits_2, b, a_debits_2)
    ]
  end

  describe '#balance' do
    before do
      transactions.each { |t| a.add_transaction t }
    end

    subject { a.balance.amount }

    it 'is the sum of all credits minus debits' do
      should == 35
    end
  end
end
