RSpec.describe Baron::Action::SellCertificates do
  let(:player) { Baron::Player.new 'a' }
  let(:player2) { Baron::Player.new 'b' }
  let(:bank) { Baron::Bank.new }
  let(:market) { Baron::Market.new rules }
  let(:game) { Baron::Game.new rules, [player, player2] }
  let(:rules) { Baron::Rules.new('1860') }

  let(:action) do
    Baron::Action::SellCertificates.new(player, bank, market, certificates)
  end

  describe '#create_transaction' do
    subject { action.create_transaction }

    let(:iow_certificates) do
      game.unavailable_certificates_pool.certificates.select do |cert|
        cert.company.abbreviation == 'IOW'
      end
    end
    let(:iow) { iow_certificates.first.company }
    let(:certificates) { iow_certificates.first(2) }

    before do
      game.unavailable_certificates_pool.give(
        player,
        iow_certificates.first(3)
      )
      market.add_company(iow, Baron::Money.new(100))
    end

    it 'transfers the certificates away from the player' do
      expect { subject }.to change { player.certificates.count }.by(-2)
    end

    it 'transfers the certificates to the bank' do
      expect { subject }.to change { bank.certificates.count }.by(2)
    end

    it 'transfers money to the player' do
      expect { subject }.to change { player.balance }.by(Baron::Money.new(300))
    end

    it 'reduces the market price of the certificates' do
      expect { subject }.to change { market.price(iow).amount }.from(100).to(86)
    end
  end
end
