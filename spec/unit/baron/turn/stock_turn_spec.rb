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

    it 'is false' do
      should be false
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
