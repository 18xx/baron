RSpec.describe Baron::Game do
  subject { described_class.new(rules, players) }
  let(:rules) { object_double(Baron::Rules) }
  let(:players) { double }

  describe '#rules' do
    it 'returns the players in this game' do
      expect(subject.rules).to eq(rules)
    end
  end

  describe '#players' do
    it 'returns the players in this game' do
      expect(subject.players).to eq(players)
    end
  end

  describe '#current_action' do
    # TODO: Make this work for more stuff
    it 'returns a winner choose auction' do
      expect(subject.current_action).to be_a Baron::Action::WinnerChooseAuction
    end

    it 'assigns the players to the round' do
      expect(subject.current_action.active_players).to eq players
    end
  end
end
