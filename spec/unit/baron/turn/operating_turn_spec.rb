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
    it { should be false }
  end

  describe '#avaiable_actions' do
    subject { turn.available_actions }

    it 'allows them to place a tile' do
      should contain_exactly(
        Baron::Action::PlaceTile,
        Baron::Action::PlaceToken
      )
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
end
