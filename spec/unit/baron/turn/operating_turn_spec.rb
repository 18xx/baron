RSpec.describe Baron::Turn::OperatingTurn do
  let(:turn) { described_class.new game, player, company }
  let(:game) { instance_double Baron::Game, bank: bank, players: [] }
  let(:bank) { Baron::Bank.new }
  let(:company) do
    Baron::Company.new('LNWR', 'London & Northwestern')
  end
  let(:player) { instance_double Baron::Player }

  describe '#game' do
    subject { turn.game }
    it 'returns the game' do
      should be game
    end
  end

  describe '#company' do
    subject { turn.company }
    it 'returns the company' do
      should be company
    end
  end

  describe '#player' do
    subject { turn.player }
    it 'returns the player of the company' do
      should be player
    end
  end

  describe '#done?' do
    subject { turn.done? }
    context 'when the comapny is not done' do
      it { should be false }
    end

    context 'when the turn is declared done' do
      before do
        turn.perform Baron::Action::RunTrains.new(turn, 0, 0)
        turn.perform Baron::Action::Done.new(turn)
      end

      it { should be true }
    end
  end

  describe '#avaiable_actions' do
    subject { turn.available_actions }

    context 'when the company has not placed tiles' do
      it 'allows them to place tiles, tokens, and run' do
        should contain_exactly(
          Baron::Action::PlaceTile,
          Baron::Action::PlaceToken,
          Baron::Action::RunTrains
        )
      end
    end

    context 'when the company has placed one tile' do
      context 'when the tile contains a large station' do
        it 'no longers allows them to place tiles'
      end

      context 'when the tiles does not contain a large station' do
        it 'still allows them to place tiles'
      end

      context 'when the tiles is an upgrade' do
        it 'no longers allows them to place tiles'
      end
    end

    context 'when the company has placed two tiles' do
      before do
        turn.perform Baron::Action::PlaceTile.new(turn, '7', 'A1', '1')
        turn.perform Baron::Action::PlaceTile.new(turn, '7', 'A2', '1')
      end

      it 'allows them to places tokens and run trains' do
        should contain_exactly(
          Baron::Action::PlaceToken,
          Baron::Action::RunTrains
        )
      end
    end

    context 'when the company has placed a token' do
      let(:action) { Baron::Action::PlaceToken.new(turn, 'A1') }
      before { turn.perform action }

      it 'allows them to run trains' do
        should contain_exactly(
          Baron::Action::RunTrains
        )
      end
    end

    context 'when the company has run trains' do
      let(:action) { Baron::Action::RunTrains.new(turn, 0, 0) }

      before do
        turn.perform action
      end

      context 'when the company runs for greater than zero' do
        let(:action) { Baron::Action::RunTrains.new(turn, 10, 0) }

        it 'allows them to payout or retain' do
          should contain_exactly(
            Baron::Action::Payout,
            Baron::Action::Retain
          )
        end

        context 'after the company pays out' do
          before do
            turn.perform Baron::Action::Payout.new(turn)
          end

          it 'allows them to buy trains, and declare it is done' do
            should contain_exactly(
              Baron::Action::BuyTrain,
              Baron::Action::Done
            )
          end
        end

        context 'after the company retains' do
          before do
            turn.perform Baron::Action::Retain.new(turn)
          end

          it 'allows them to buy trains, and declare it is done' do
            should contain_exactly(
              Baron::Action::BuyTrain,
              Baron::Action::Done
            )
          end
        end
      end

      context 'when the company runs for nothing' do
        it 'allows them to buy trains, and declare it is done' do
          should contain_exactly(
            Baron::Action::BuyTrain,
            Baron::Action::Done
          )
        end

        context 'when the company has declared it is done' do
          before { turn.perform Baron::Action::Done.new(turn) }

          it { should be_empty }
        end
      end
    end
  end

  describe 'place tile' do
    let(:tile) { double }
    let(:hex) { double }
    let(:orientation) { double }
    let(:player) { instance_double Baron::Player, 'player' }
    let(:action) do
      Baron::Action::PlaceTile.new(
        turn,
        tile,
        hex,
        orientation
      )
    end

    subject { turn.perform action }

    it 'is a no-op' do
      expect { subject }.to_not raise_error
    end
  end

  describe 'place token' do
    let(:hex) { double }
    let(:player) { instance_double Baron::Player, 'player' }
    let(:action) { Baron::Action::PlaceToken.new(turn, hex) }

    subject { turn.perform action }

    it 'is a no-op' do
      expect { subject }.to_not raise_error
    end
  end

  describe 'run trains' do
    let(:action) do
      Baron::Action::RunTrains.new(turn, amount, corporate_bonus)
    end
    let(:amount) { double }
    let(:corporate_bonus) { double }

    subject { turn.perform action }

    it 'is a no-op' do
      expect { subject }.to_not raise_error
    end
  end

  describe 'payout' do
    let(:game) do
      instance_double(
        Baron::Game,
        bank: bank,
        players: players
      )
    end

    let(:bank) { instance_double Baron::Bank }
    let(:company) { instance_double Baron::Company }
    let(:players) { [player1, player2, player3] }
    let(:player1) { instance_double Baron::Player, 'P1' }
    let(:player2) { instance_double Baron::Player, 'P2' }
    let(:player3) { instance_double Baron::Player, 'P3' }

    describe 'transactions' do
      before do
        allow(player1).to receive(:percentage_owned).with(company).and_return(
          BigDecimal.new('0.6')
        )
        allow(player2).to receive(:percentage_owned).with(company).and_return(
          BigDecimal.new('0.1')
        )
        allow(player3).to receive(:percentage_owned).with(company).and_return(
          BigDecimal.new('0.0')
        )
        turn.perform Baron::Action::RunTrains.new(turn, 10, 0)
      end

      let(:action) { Baron::Action::Payout.new turn }

      subject { turn.perform action }

      context 'when the company runs for 10' do
        it 'pays out players 1 & 2' do
          expect(bank).to receive(:give).with(player1, Baron::Money.new(6))
          expect(bank).to receive(:give).with(player2, Baron::Money.new(1))
          expect(bank).to_not receive(:give).with(player3, Baron::Money.new(0))
          subject
        end
      end
    end
  end

  describe 'retain' do
    let(:game) do
      instance_double(
        Baron::Game,
        bank: bank,
        players: players
      )
    end

    let(:bank) { Baron::Bank.new }
    let(:players) { [player1, player2, player3] }
    let(:player1) { instance_double Baron::Player, 'P1' }
    let(:player2) { instance_double Baron::Player, 'P2' }
    let(:player3) { instance_double Baron::Player, 'P3' }

    let(:action) { Baron::Action::Retain.new turn }
    before do
      turn.perform Baron::Action::RunTrains.new(turn, 100, 0)
    end
    subject { turn.perform action }

    it 'transfers the earnings to the company' do
      expect { subject }.to change { company.balance }.by(Baron::Money.new(100))
    end

    it 'transfers the earnings from the bank' do
      expect { subject }.to change { bank.balance }.by(Baron::Money.new(-100))
    end
  end
end
