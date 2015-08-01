RSpec.describe Baron::Action::SelectCertificate do
  let(:player) { object_double Baron::Player }
  let(:certificate) { object_double Baron::Certificate }

  let(:action) { described_class.new player, certificate }

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
