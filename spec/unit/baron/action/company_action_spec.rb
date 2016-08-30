# frozen_string_literal: true
RSpec.describe Baron::Action::CompanyAction do
  let(:turn) { instance_double Baron::Turn, player: player }
  let(:player) { instance_double Baron::Player, 'player' }
  let(:action) { Baron::Action::CompanyAction.new(turn) }

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
end
