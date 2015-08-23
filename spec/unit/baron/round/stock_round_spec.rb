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

  describe '#current_player' do
    subject { stock_round.current_player }

    it 'returns the player whose turn it currently is' do
      should be player1
    end
  end

  describe '#current_turn' do
    subject { stock_round.current_turn }

    context 'when the turn has not been initialized' do
      it 'returns a new stock turn' do
        expect(subject).to be_a Baron::Turn::StockTurn
      end

      it 'is for the first player' do
        expect(subject.player).to be player1
      end

      it 'is for this stock round' do
        expect(subject.round).to be stock_round
      end
    end

    context 'when the the turn is called consecutively' do
      context 'when the turn is done' do
        before do
          subject
          allow(subject).to receive(:done?).and_return(true)
        end

        it 'returns a new turn' do
          expect(subject).to_not be stock_round.current_turn
        end

        it 'is for the next player' do
          expect(stock_round.current_turn.player).to be player2
        end
      end

      context 'when the turn is not done' do
        it 'returns the same turn' do
          expect(subject).to be stock_round.current_turn
        end
      end
    end
  end

  describe '#over?' do
    subject { stock_round.over? }

    context 'when all players have passed consecutively' do
      it 'should be true'
    end

    context 'when all players have not passed consecutively' do
      it { should be false }
    end
  end
end
