# frozen_string_literal: true
RSpec.describe Baron::Action::PlaceToken do
  let(:turn) { instance_double Baron::Turn, player: player }
  let(:hex) { double }
  let(:player) { instance_double Baron::Player, 'player' }
  let(:action) { described_class.new turn, hex }

  describe '#player' do
    subject { action.player }
    it 'returns the player for the turn' do
      should be player
    end
  end

  describe '#turn' do
    subject { action.turn }
    it 'returns the turn for this action' do
      should be turn
    end
  end

  describe '#hex' do
    subject { action.hex }
    it 'returns the hex for this action' do
      should be hex
    end
  end
end
