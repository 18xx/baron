RSpec.describe Baron::Game do
  let(:game) { described_class.new(rules, players) }
  let(:rules) { Baron::Rules.new('1860') }
  let(:player_a) { Baron::Player.new('a') }
  let(:player_b) { Baron::Player.new('b') }
  let(:players) do
    [
      player_a,
      player_b
    ]
  end

  subject { game }

  describe '#bank' do
    it 'starts with a a large amount of money' do
      # $100MM - $2000 in starting capital
      expect(subject.bank.balance).to eq Baron::Money.new(99_998_000)
    end
  end

  describe '#initial_offering' do
    subject { game.initial_offering }

    context 'when the game first starts' do
      it 'has no certificates' do
        expect(subject.certificates).to be_empty
      end
    end
  end

  describe '#market' do
    subject { game.market }

    it 'is a market' do
      expect(subject).to be_a Baron::Market
    end

    it 'assigns the rules' do
      expect(subject.rules).to be rules
    end
  end

  describe '#unavailable_certificates_pool' do
    subject { game.unavailable_certificates_pool }

    it 'starts with 77 certificates' do
      # 72 major company certs & 5 privates
      expect(subject.certificates.count).to eq 77
    end

    it 'has certificates for the 13 companies' do
      expect(
        subject.certificates.map(&:company).uniq.count
      ).to eq 13
    end

    it 'has certificates for the 8 directors certificates' do
      expect(
        subject.certificates.map(&:portion).count do |portion|
          portion == 0.2
        end
      ).to eq 8
    end

    it 'has certificates for the 5 private companies' do
      expect(
        subject.certificates.count do |certificate|
          certificate.company.instance_of? Baron::Company::PrivateCompany
        end
      ).to eq 5
    end

    it 'has certificates for the 5 private companies' do
      private_certificates = subject.certificates
      private_certificates.select! do |certificate|
        certificate.company.instance_of? Baron::Company::PrivateCompany
      end
      expect(
        private_certificates.all? { |certificate| certificate.portion == 1 }
      ).to be true
    end
  end

  describe '#rules' do
    it 'returns the players in this game' do
      expect(subject.rules).to eq(rules)
    end
  end

  describe '#players' do
    subject { game.players }

    it 'returns the players in this game' do
      expect(subject).to eq(players)
    end

    it 'freezes players' do
      should be_frozen
    end

    it 'gives the players their starting capital' do
      expect(
        subject.all? do |player|
          player.balance == Baron::Money.new(1000)
        end
      ).to be true
    end
  end

  describe '#current_round' do
    subject { game.current_round }

    let(:round) { double }

    before do
      expect_any_instance_of(Baron::GameRoundFlow).to receive(
        :current_round
      ).and_return(round)
    end

    it 'returns the current round from the game flow' do
      should be round
    end
  end

  describe '#current_turn' do
    # TODO: Make this work for more stuff
    it 'returns a winner choose auction' do
      expect(subject.current_turn).to be_a(
        Baron::Turn::WinnerChooseAuction
      )
    end

    it 'assigns the players to the round' do
      expect(subject.current_turn.active_players).to eq players
    end

    it 'copies the assignment' do
      expect(subject.current_turn.active_players).to_not equal players
    end

    it 'assigns the bank to the round' do
      expect(subject.current_turn.bank).to equal subject.bank
    end
  end

  describe '#current_player' do
    it 'returns the first player' do
      expect(subject.current_player).to eq players.first
    end
  end

  describe '#director' do
    subject { game.director(company) }
    let(:company) { double }
    let(:directors_certificate) do
      Baron::Certificate.new company, BigDecimal.new('0.2')
    end

    context 'when a company has no director' do
      it { should be nil }
    end

    context 'when player a is the director' do
      before do
        player_a.grant directors_certificate
      end

      it { should be player_a }
    end
  end

  describe '#inspect' do
    subject { game.inspect }

    it 'returns a string representation of the object' do
      should eq(
        "#<Baron::Game:#{game.object_id}>"
      )
    end
  end

  describe '#over?' do
    subject { game.over? }

    it 'returns false' do
      should be false
    end
  end

  describe 'trains' do
    it 'puts the current set of trains in the initial offering' do
      expect(subject.initial_offering.trains.count).to be 5
    end

    it 'puts the rest of the trains in the unavailable certificates pool' do
      expect(subject.unavailable_certificates_pool.trains.count).to be 29
    end
  end
end
