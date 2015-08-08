RSpec.describe Baron::Game do
  let(:game) { described_class.new(rules, players) }
  let(:rules) { Baron::Rules.new('1860') }
  let(:players) do
    [
      Baron::Player.new('a'),
      Baron::Player.new('b')
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
    it 'returns the players in this game' do
      expect(subject.players).to eq(players)
    end

    it 'gives the players their starting capital' do
      expect(
        subject.players.all? do |player|
          player.balance == Baron::Money.new(1000)
        end
      ).to be true
    end
  end

  describe '#current_round' do
    subject { game.current_round }

    context 'at the start of the game' do
      it 'is an initial auction round' do
        expect(subject).to be_a Baron::Round::InitialAuction
      end

      it 'assigns this game to the round' do
        expect(subject.game).to be game
      end
    end

    context 'after the auction round has ended' do
      before do
        round = game.current_round
        allow(round).to receive(:over?) { true }
      end

      it 'is a stock round' do
        expect(subject).to be_a Baron::Round::StockRound
      end

      it 'assigns this game to the round' do
        expect(subject.game).to be game
      end
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

    it 'copies the assignment' do
      expect(subject.current_operation.active_players).to_not equal players
    end

    it 'assigns the bank to the round' do
      expect(subject.current_operation.bank).to equal subject.bank
    end
  end
end
