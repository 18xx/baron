RSpec.describe Baron::Game do
  subject { described_class.new(rules, players) }
  let(:rules) { Baron::Rules.new('1860') }
  let(:players) { double }

  describe '#bank' do
    it 'starts with 100_000' do
      expect(subject.bank.balance).to eq Baron::Money.new(100_000_000)
    end
  end

  describe '#initial_offering' do
    it 'starts with 72 certificates' do
      expect(subject.initial_offering.certificates.count).to eq 72
    end

    it 'has certificates for the 8 companies' do
      expect(
        subject.initial_offering.certificates.map(&:company).uniq.count
      ).to eq 8
    end

    it 'has certificates for the 8 directors certificates' do
      expect(
        subject.initial_offering.certificates.map(&:portion).count do |portion|
          portion == 0.2
        end
      ).to eq 8
    end

    it 'has certificates for the 8 companies' do
      expect(
        subject.initial_offering.certificates.map(&:company).uniq.count
      ).to eq 8
    end
  end

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

  describe '#current_operation' do
    # TODO: Make this work for more stuff
    it 'returns a winner choose auction' do
      expect(subject.current_operation).to be_a(
        Baron::Operation::WinnerChooseAuction
      )
    end

    it 'assigns the players to the round' do
      expect(subject.current_operation.active_players).to eq players
    end
  end
end
