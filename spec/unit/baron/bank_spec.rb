RSpec.describe Baron::Bank do
  let(:bank) { described_class.new game }
  let(:game) { instance_double Baron::Game, market: market }
  let(:market) { double }

  describe '#inspect' do
    it 'returns a string representation of the object' do
      expect(bank.inspect).to eq(
        "#<Baron::Bank:#{bank.object_id}>"
      )
    end
  end

  describe '#cost' do
    let(:certificate) { instance_double Baron::Certificate }
    subject { bank.cost certificate }

    it 'retutns the market cost of the certificate' do
      expect(certificate).to receive(:market_cost).with(market)
      subject
    end
  end
end
