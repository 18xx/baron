RSpec.describe Baron::Turn::OperatingTurn do
  let(:turn) { described_class.new player, company }
  let(:company) { instance_double Baron::Company }
  let(:player) { instance_double Baron::Player }

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
end
