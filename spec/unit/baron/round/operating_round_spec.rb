RSpec.describe Baron::Round::OperatingRound do
  let(:round) { described_class.new game }

  let!(:game) { Baron::Game.new(rules, players) }
  let(:rules) { Baron::Rules.new '1860' }
  let(:players) { [player1, player2] }
  let(:player1) { Baron::Player.new 'a' }
  let(:player2) { Baron::Player.new 'b' }

  describe '#game' do
    subject { round.game }
    it 'returns the game' do
      should be game
    end
  end

  describe 'initialization' do
    let(:private_company) do
      Baron::Company::PrivateCompany.new(
        'C&A',
        'Camden and Amboy',
        face_value: Baron::Money.new(160),
        revenue: Baron::Money.new(25)
      )
    end
    let(:certificate) do
      Baron::Certificate.new(private_company, BigDecimal.new(1))
    end

    before do
      player1.grant certificate
    end

    it 'pays out private companies' do
      expect { round }.to change { player1.balance.amount }.by(25)
    end

    it 'pays the money out from the bank' do
      expect { round }.to change { game.bank.balance.amount }.by(-25)
    end
  end

  describe '#current_turn' do
    let(:market) { instance_double Baron::Market, operating_order: order }
    before do
      allow(game).to receive(:market).and_return(market)
    end
    let(:company1) { instance_double Baron::Company, 'c1' }
    let(:company2) { instance_double Baron::Company, 'c2' }
    let(:order) { [company1, company2] }

    subject { round.current_turn }

    context 'when no one has taken a turn' do
      let(:director) { double }
      before do
        expect(game).to receive(:director).with(company1).and_return(director)
        expect(game).to receive(:director).with(company2).and_return(double)
      end

      it 'returns the first turn' do
        expect(subject.company).to be company1
      end

      it 'sets the director' do
        expect(subject.player).to be director
      end
    end

    context 'when the turn completes' do
      before do
        turn = round.current_turn
        allow(turn).to receive(:done?).and_return true
      end

      it 'returns the next turn' do
        expect(subject.company).to be company2
      end
    end

    context 'when everyone has taken a turn' do
      before do
        2.times do
          turn = round.current_turn
          allow(turn).to receive(:done?).and_return true
        end
      end

      it { should be_nil }
    end
  end
end
