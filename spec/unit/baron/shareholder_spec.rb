# frozen_string_literal: true
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

  let(:transactions) do
    [
      Baron::Transaction.new(a, a_credits, b, a_debits),
      Baron::Transaction.new(a, a_credits_2, b, a_debits_2)
    ]
  end

  before do
    a_certificate.owner = b
    transactions
  end

  describe '#balance' do
    subject { a.balance.amount }

    it 'is the sum of all credits minus debits' do
      should == 35
    end

    context 'when there are no debits' do
      let(:a_debits) { [] }
      let(:a_debits_2) { [] }

      it 'is the sum of all credits' do
        should == 110
      end
    end
  end

  describe '#certificates' do
    let(:certificate) { Baron::Certificate.new company, BigDecimal.new('0.1') }
    subject { a.certificates }

    context 'when the shareholder has nothing' do
      let(:transactions) { nil }
      it { should be_empty }
    end

    context 'when the shareholder has acquired something' do
      before do
        a.grant certificate
      end

      it 'includes those certificates' do
        should contain_exactly a_certificate, certificate
      end
    end

    context 'when the shareholder has sold certificates' do
      let(:transactions) do
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
      let(:transactions) do
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

  describe '#trains' do
    let(:train) { Baron::Train.new double }
    subject { a.trains }

    context 'when the shareholder has nothing' do
      let(:transactions) { nil }
      it { should be_empty }
    end

    context 'when the shareholder has acquired something' do
      before { a.grant train }

      it 'includes those trains' do
        should contain_exactly train
      end
    end

    context 'when the shareholder has sold trains' do
      let(:other_train) { Baron::Train.new double }
      before do
        a.grant train
        a.grant other_train
        Baron::Transaction.new(a, [], nil, [train])
      end

      it 'does not include trains they have sold' do
        should contain_exactly other_train
      end
    end
  end

  describe '#certificates_for' do
    let(:certificate) { Baron::Certificate.new company, BigDecimal.new('0.1') }
    let(:requested_company) { company }
    subject { a.certificates_for requested_company }

    context 'when the shareholder has nothing' do
      let(:transactions) { nil }
      it { should be_empty }
    end

    context 'when the shareholder has certificates' do
      let(:transactions) do
        a.grant certificate
      end

      context 'when the requested company matches a certificate' do
        it { should match_array [certificate] }
      end

      context 'when the shareholder has none of the requested company certs' do
        let(:requested_company) { double }

        it { should be_empty }
      end
    end
  end

  describe '#percengage_owned' do
    let(:certificates) do
      [
        Baron::Certificate.new(double, BigDecimal.new('0.1')),
        Baron::Certificate.new(company, BigDecimal.new('0.1')),
        Baron::Certificate.new(company, BigDecimal.new('0.1'))
      ]
    end

    let(:requested_company) { company }
    subject { a.percentage_owned requested_company }

    context 'when the shareholder has nothing' do
      let(:transactions) { nil }
      it { should be_zero }
    end

    context 'when the shareholder has certificates' do
      let(:transactions) do
        [
          Baron::Transaction.new(a, certificates, nil, [])
        ]
      end

      context 'when the requested company matches a certificate' do
        it 'returns the sum of the portions' do
          should eq BigDecimal.new('0.2')
        end
      end

      context 'when the shareholder has none of the requested company certs' do
        let(:requested_company) { double }

        it { should be_zero }
      end
    end
  end

  describe '#directorships' do
    subject { a.directorships }

    context 'when the shareholder is not a director of a company' do
      subject { b.directorships }
      it { should be_empty }
    end

    context 'when the shareholder holds the directors share' do
      let(:a_certificate) do
        Baron::Certificate.new company, BigDecimal.new('0.2')
      end

      it 'includes that company in the list of directorships' do
        should include company
      end
    end

    context 'when the shareholder only holds a non-directors share' do
      it 'does not includes that company in the list of directorships' do
        should be_empty
      end
    end
  end

  describe '#private_certificates' do
    subject { a.private_certificates }

    context 'when the shareholder has no private certificates' do
      it { should be_empty }
    end

    context 'when the shareholder has private certificates' do
      let(:company) do
        Baron::Company::PrivateCompany.new(
          'LNWR',
          nil,
          face_value: Baron::Money.new(100),
          revenue: Baron::Money.new(10)
        )
      end

      it 'returns the private certificates' do
        should match_array([a_certificate])
      end
    end
  end

  describe '#give' do
    subject { a.give(b, Baron::Money.new(10)) }

    it 'gives the item to the specified shareholder' do
      expect { subject }.to change { b.balance.amount }.by(10)
    end

    it 'deducts the amount from this shareholder' do
      expect { subject }.to change { a.balance.amount }.by(-10)
    end

    context 'when given an array' do
      subject { a.give(b, [Baron::Money.new(10), Baron::Money.new(20)]) }

      it 'gives the total to the specified shareholder' do
        expect { subject }.to change { b.balance.amount }.by(30)
      end

      it 'deducts the total from this shareholder' do
        expect { subject }.to change { a.balance.amount }.by(-30)
      end
    end
  end

  describe '#grant' do
    context 'when the parameter is not an array' do
      subject { a.grant(Baron::Money.new(10)) }

      it 'gives the item to the specified shareholder' do
        expect { subject }.to change { a.balance.amount }.by(10)
      end
    end

    context 'when the parameter is an array' do
      subject { a.grant([Baron::Money.new(10), Baron::Money.new(20)]) }

      it 'gives the item to the specified shareholder' do
        expect { subject }.to change { a.balance.amount }.by(30)
      end
    end
  end

  describe '#largest_train' do
    subject { a.largest_train }

    context 'when the company owns no trains' do
      it { should be nil }
    end

    context 'when the company owns trains' do
      let(:type2) { Baron::TrainType.new(2, nil) }
      let(:type3) { Baron::TrainType.new(3, nil) }

      before do
        a.grant Baron::Train.new(type2)
        a.grant Baron::Train.new(type3)
      end

      it 'returns the major station allowance of the largest train' do
        should be 3
      end
    end
  end
end
