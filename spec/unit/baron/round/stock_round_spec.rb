# frozen_string_literal: true
RSpec.describe Baron::Round::StockRound do
  let(:stock_round) { described_class.new game, priority_deal }

  let(:priority_deal) { player1 }
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
        game.unavailable_certificates_pool.give player1, certificate
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

    context 'when player2 has priority deal' do
      let(:priority_deal) { player2 }

      it 'makes player2 go first' do
        should be player2
      end
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
    let(:certificate) { instance_double Baron::Certificate, company: company }
    let(:company) do
      instance_double Baron::Company::MajorCompany, floated?: true
    end

    subject { stock_round.over? }

    context 'when all players have passed consecutively' do
      before do
        passers.each do |player|
          stock_round.current_turn.perform(Baron::Action::Pass.new(player))
        end
      end

      context 'when not all players have had a turn' do
        let(:passers) { [player1, player2] }
        it { should be false }
      end

      context 'when all players have had a turn' do
        let(:passers) { players }
        it { should be true }
      end
    end

    context 'when all players have not passed consecutively' do
      let(:buy_action) do
        Baron::Action::BuyCertificate.new(
          player3,
          nil,
          certificate
        )
      end
      before do
        allow(buy_action).to receive(:create_transaction)
        [player1, player2].each do |player|
          stock_round.current_turn.perform Baron::Action::Pass.new(player)
        end
        stock_round.current_turn.perform buy_action
        [player1, player2].each do |player|
          stock_round.current_turn.perform Baron::Action::Pass.new(player)
        end
      end
      it { should be false }

      context 'when all players have passed in a row' do
        before do
          stock_round.current_turn.perform Baron::Action::Pass.new(player3)
        end
        it { should be true }
      end
    end
  end

  describe '#next_priority_deal' do
    subject { stock_round.next_priority_deal }
    context 'when the round is not over' do
      it 'raises a RoundNotOver error' do
        expect { subject }.to raise_error(Baron::Round::RoundNotOver)
      end
    end

    context 'when the round is over' do
      context 'when no one acted' do
        it 'lets the starting player go first' do
          stock_round.current_turn.perform Baron::Action::Pass.new(player1)
          stock_round.current_turn.perform Baron::Action::Pass.new(player2)
          stock_round.current_turn.perform Baron::Action::Pass.new(player3)
          expect(subject).to be player1
        end
      end

      context 'when some players have acted' do
        let(:unavailable_pool) { game.unavailable_certificates_pool }
        let(:ipo) { game.initial_offering }
        let(:certificate) do
          unavailable_pool.certificates.find do |cert|
            cert.portion == BigDecimal.new('0.1')
          end
        end
        let(:company) { certificate.company }

        before do
          unavailable_pool.give(ipo, certificate)
          ipo.set_par_price company, Baron::Money.new(100)
        end

        it 'lets the player after the last acting player go first' do
          stock_round.current_turn.perform(
            Baron::Action::BuyCertificate.new(
              player1,
              ipo,
              certificate
            )
          )
          stock_round.current_turn.perform Baron::Action::Pass.new(player2)
          stock_round.current_turn.perform Baron::Action::Pass.new(player3)
          stock_round.current_turn.perform Baron::Action::Pass.new(player1)
          expect(subject).to be player2
        end
      end
    end
  end
end
