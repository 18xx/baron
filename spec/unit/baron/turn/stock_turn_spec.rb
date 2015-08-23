RSpec.describe Baron::Turn::StockTurn do
  let(:turn) { described_class.new player, round }

  let(:player) { instance_double Baron::Player }
  let(:round) { instance_double Baron::Round::StockRound }

  describe '#player' do
    subject { turn.player }

    it 'returns the player' do
      should be player
    end
  end

  describe '#round' do
    subject { turn.round }

    it 'returns the round' do
      should be round
    end
  end

  describe '#done?' do
    subject { turn.done? }

    context 'when the user has not bought a certificate' do
      it { should be false }
    end

    context 'when the user has bought a certificate' do
      before do
        allow(Baron::Action::BuyCertificate).to receive(:new)
        turn.buy_certificate nil, nil
      end

      it { should be true }
    end
  end

  describe '#buy_certificate' do
    let(:source) { double }
    let(:certificate) { double }
    subject { turn.buy_certificate source, certificate }

    it 'creates a buy certificate action' do
      expect(Baron::Action::BuyCertificate).to receive(:new).with(
        player, source, certificate
      )
      subject
    end
  end

  describe '#available_actions' do
    subject { turn.available_actions }

    context 'when the player has not taken an action' do
      it 'allows the player to buy, or pass' do
        should match_array([
          Baron::Action::BuyCertificate,
          Baron::Action::Pass
        ])
      end
    end
  end
end
