# frozen_string_literal: true
RSpec.describe Baron::GameRoundFlow do
  let(:game) { Baron::Game.new(rules, players) }
  let(:rules) { Baron::Rules.new('1860') }
  let(:player_a) { Baron::Player.new('a') }
  let(:player_b) { Baron::Player.new('b') }
  let(:players) do
    [
      player_a,
      player_b
    ]
  end
  let(:flow) { described_class.new game }

  describe '#current_round' do
    subject { flow.current_round }

    context 'at the start of the game' do
      it 'is an initial auction round' do
        expect(subject).to be_a Baron::Round::InitialAuction
      end

      it 'assigns this game to the round' do
        expect(subject.game).to be game
      end
    end

    context 'after the auction round has ended' do
      before do
        round = flow.current_round
        allow(round).to receive(:over?) { true }
        allow(round).to receive(:next_priority_deal) { player_a }
      end

      it 'is a stock round' do
        expect(subject).to be_a Baron::Round::StockRound
      end

      it 'assigns this game to the round' do
        expect(subject.game).to be game
      end

      context 'after the stock round has ended' do
        before do
          round = flow.current_round
          allow(round).to receive(:over?) { true }
          allow(round).to receive(:next_priority_deal) { player_a }
        end

        it 'is a operating round' do
          expect(subject).to be_a Baron::Round::OperatingRound
        end

        it 'assigns this game to the round' do
          expect(subject.game).to be game
        end

        context 'after that operating round has ended' do
          before do
            round = flow.current_round
            allow(round).to receive(:over?) { true }
          end

          context 'when the game is not over' do
            it 'returns a new stock round' do
              expect(subject).to be_a Baron::Round::StockRound
            end
          end

          context 'when the game is over' do
            before do
              round = flow.current_round
              allow(round).to receive(:over?) { true }
              allow(game).to receive(:over?) { true }
            end

            it 'returns nil' do
              expect(subject).to be nil
            end
          end
        end
      end
    end
  end
end
