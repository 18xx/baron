RSpec.describe Baron::Action::SelectPrivateCompany do
  let(:player) { object_double Baron::Player }
  let(:company) { object_double Baron::Company::PrivateCompany }

  let(:bid) { described_class.new player, company }

  describe '#player' do
    it 'returns the player' do
      expect(bid.player).to eq(player)
    end
  end

  describe '#company' do
    it 'return the company' do
      expect(bid.company).to eq(company)
    end
  end
end
