RSpec.describe Baron::Action::BuyCertificate do
  let(:player) { Baron::Player.new 'a' }
  let(:source) { Baron::InitialOffering.new }
  let(:certificate) { Baron::Certificate.new company, BigDecimal.new('0.1') }
  let(:company) { instance_double Baron::Company }

  let(:action) { described_class.new player, source, certificate }

  before do
    source.set_par_price(company, Baron::Money.new(90))
  end

  describe '#create_transaction' do
    before do
      source.grant certificate
    end

    subject { action.create_transaction }

    it 'transfers the certificate to the player' do
      expect { subject }.to change { player.certificates.count }.by(1)
    end

    it 'deducts money from the player' do
      expect { subject }.to change { player.balance }.by(Baron::Money.new(-90))
    end

    it 'transfers the certificiate away from the source' do
      expect { subject }.to change { source.certificates.count }.by(-1)
    end

    it 'adds money to the source' do
      expect { subject }.to change { source.balance }.by(Baron::Money.new(90))
    end
  end
end
