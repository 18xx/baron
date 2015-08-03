RSpec.describe Baron::Action::SelectCertificate do
  let(:action) { described_class.new game, player, certificate }

  let(:certificate) { instance_double(Baron::Certificate, company: company) }

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
    Baron::InitialOffering.new
  end

  let(:player) { instance_double Baron::Player, add_transaction: nil }

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
