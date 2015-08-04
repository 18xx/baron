RSpec.describe Baron::Money do
  subject { Baron::Money.new amount }

  let(:amount) { 15 }

  describe 'initialization' do
    context 'when no parameter is specified' do
      subject { Baron::Money.new }

      it 'leaves the amount as 0' do
        expect(subject.amount).to eq 0
      end
    end

    context 'when amount is not a fixnum' do
      let(:amount) { '15' }
      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#amount' do
    it 'returns the amount' do
      expect(subject.amount).to eq 15
    end
  end

  describe '#to_int' do
    it 'returns an integer of the amount' do
      expect(subject.to_int).to eq 15
    end
  end

  describe '#to_s' do
    it 'returns a string of the amount with a currency symbol' do
      expect(subject.to_s).to eq '$15'
    end
  end

  describe 'adding' do
    let(:other_money) { Baron::Money.new 10 }

    it 'adds the two amounts and returns a new money' do
      expect((subject + other_money).amount).to eq 25
    end
  end

  describe 'subtracting' do
    let(:other_money) { Baron::Money.new 10 }

    it 'adds the two amounts and returns a new money' do
      expect((subject - other_money).amount).to eq 5
    end
  end

  describe 'multiplying' do
    let(:value) { 2 }

    it 'multiples the money and returns a new money' do
      expect((subject * value).amount).to eq 30
    end
  end

  describe 'comparing' do
    context 'when subject is greater' do
      let(:other_money) { Baron::Money.new 10 }
      specify do
        expect(subject < other_money).to be false
        expect(subject > other_money).to be true
      end
    end

    context 'when subject is equal' do
      let(:other_money) { Baron::Money.new 15 }
      specify do
        expect(subject == other_money).to be true
        expect(subject.equal? other_money).to be false
      end
    end

    context 'when subject is less' do
      let(:other_money) { Baron::Money.new 20 }
      specify do
        expect(subject < other_money).to be true
        expect(subject > other_money).to be false
      end
    end
  end
end
