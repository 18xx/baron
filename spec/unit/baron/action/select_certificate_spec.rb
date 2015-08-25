RSpec.describe Baron::Action::SelectCertificate do
  let(:action) { described_class.new game, player, certificate }

  let(:certificate) do
    Baron::Certificate.new company, BigDecimal.new('0.1')
  end

  let(:company) do
    instance_double(
      Baron::Company::PrivateCompany,
      face_value: Baron::Money.new(100)
    )
  end

  let(:game) do
    instance_double Baron::Game, initial_offering: initial_offering
  end

  let(:initial_offering) do
    Baron::InitialOffering.new market
  end
  let(:market) { double }

  let(:player) { instance_double Baron::Player, add_transaction: nil }

  before do
    certificate.owner = initial_offering
  end

  subject { action }

  describe 'initialization' do
    it 'creates a transaction for this process' do
      expect(Baron::Transaction).to receive(:new).with(
        player,
        [certificate],
        initial_offering,
        [Baron::Money.new(100)]
      )
      subject
    end

    context 'par price is not specified' do
      it 'does not set the par price on the initial offering' do
        expect(initial_offering).to_not receive(:set_par_price)
        subject
      end
    end

    context 'when setting a par price' do
      let(:action) { described_class.new game, player, certificate, par_price }
      let(:par_price) { Baron::Money.new(90) }

      it 'sets the par price on the initial offering' do
        expect(initial_offering).to receive(:set_par_price).with(
          company,
          par_price
        )
        subject
      end
    end
  end

  describe '#player' do
    it 'returns the player' do
      expect(action.player).to eq(player)
    end
  end

  describe '#certificate' do
    it 'return the company' do
      expect(action.certificate).to eq(certificate)
    end
  end
end
