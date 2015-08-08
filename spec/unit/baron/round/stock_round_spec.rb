RSpec.describe Baron::Round::StockRound do
  let(:stock_round) { described_class.new game }

  let(:player1) { Baron::Player.new '1' }
  let(:player2) { Baron::Player.new '2' }
  let(:player3) { Baron::Player.new '3' }
  let(:players) do
    [player1, player2, player3]
  end

  let(:game) { Baron::Game.new rules, players }
  let(:rules) { Baron::Rules.new '1860' }

  describe 'initialization' do
    subject { stock_round }

    it 'makes directorships available' do
      expect { subject }.to change { game.initial_offering.certificates.count }
        .from(0).to(8)
    end

    context 'when a directors certificate has been sold' do
      let(:certificate) do
        game.unavailable_certificates_pool.certificates.find(&:director?)
      end

      before do
        Baron::Transaction.new(
          player1,
          [certificate],
          game.unavailable_certificates_pool,
          []
        )
      end

      it 'makes directorships and non-directors certificates available ' do
        expect { subject }.to change {
          game.initial_offering.certificates.count
        }.from(0).to(15)
      end
    end
  end

  describe '#game' do
    subject { stock_round.game }

    it 'returns the game' do
      should be game
    end
  end
end
