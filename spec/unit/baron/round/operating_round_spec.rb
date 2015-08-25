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
end
