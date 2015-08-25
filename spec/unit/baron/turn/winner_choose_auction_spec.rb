RSpec.describe Baron::Turn::WinnerChooseAuction do
  let(:player1) do
    Baron::Player.new('Bart')
  end

  let(:player2) do
    Baron::Player.new('Lisa')
  end

  let(:player3) do
    Baron::Player.new('Maggie')
  end

  let(:bank) { Baron::Bank.new }

  let(:players) { [player1, player2, player3] }

  let(:auction) { described_class.new(players, bank) }

  subject { auction }

  let(:bid) { Baron::Action::Bid.new(bid_player, bid_amount) }
  let(:bid_player) { player1 }
  let(:bid_amount) { Baron::Money.new 10 }

  let(:initial_offering) { Baron::InitialOffering.new market }
  let(:market) { double }

  let(:company) do
    instance_double(
      Baron::Company::PrivateCompany,
      face_value: Baron::Money.new(100)
    )
  end

  let(:certificate) do
    Baron::Certificate.new company, BigDecimal.new('0.1')
  end

  before do
    certificate.owner = initial_offering
  end

  describe '#active_players' do
    it 'copies players' do
      expect(subject.active_players).to eq players
      expect(subject.active_players).to_not equal players
    end
  end

  describe '#bid' do
    context 'when the bid is legal' do
      it 'changes the current bid' do
        subject.bid bid
        expect(subject.current_bid).to eq bid
      end

      it 'changes the high bidder' do
        subject.bid bid
        expect(subject.high_bidder).to eq(player1)
      end

      it 'moves the active player to the next player' do
        subject.bid bid
        expect(subject.player).to eq(player2)
      end

      it 'keeps the bidding player active' do
        subject.bid bid
        expect(subject.active_players).to include player1
      end
    end

    context 'when the bid is 0' do
      let(:amount) { 0 }
      it 'is legal' do
        expect { subject.bid bid }.to_not raise_error
      end
    end

    context 'when the bid is less than the current high bid' do
      let(:new_bid) { Baron::Action::Bid.new(player2, Baron::Money.new(5)) }

      before do
        subject.bid bid
      end

      it 'raises an error' do
        expect { subject.bid new_bid }.to raise_error(
          Baron::Action::IllegalBidAmount,
          'Amount must be greater than previous bids'
        )
      end
    end

    context 'when the bid is equal to the current high bid' do
      let(:bid_amount) { Baron::Money.new 5 }
      let(:new_bid) { Baron::Action::Bid.new(player2, Baron::Money.new(5)) }

      before do
        subject.bid bid
      end

      it 'raises an error' do
        expect { subject.bid new_bid }.to raise_error(
          Baron::Action::IllegalBidAmount,
          'Amount must be greater than previous bids'
        )
      end
    end

    context 'when it is not the players turn' do
      let(:bid_player) { player2 }

      it 'raises a wrong turn error' do
        expect { subject.bid bid }.to raise_error(
          Baron::Turn::WrongTurn,
          "Lisa bid, but it is Bart's turn"
        )
      end
    end
  end

  describe '#pass' do
    it 'removes the player from the active players' do
      subject.pass
      expect(subject.active_players).to_not include player1
    end

    context 'when it does not lead to a winning bid' do
      it 'does not cause money to change hands' do
        expect(bank).to_not receive(:add_transaction)
      end
    end

    context 'when it leads to a winning bid' do
      before do
        subject.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
        subject.pass
      end

      it 'transfers the bid from winning player' do
        expect { subject.pass }.to change { player1.balance.amount }.by(-5)
      end

      it 'transfers the bid to the bank' do
        expect { subject.pass }.to change { bank.balance.amount }.by(5)
      end
    end
  end

  describe '#player' do
    context 'when no one has acted' do
      it 'is the first player' do
        expect(subject.player).to eq player1
      end
    end

    context 'when some players have bid' do
      it 'is the next player in order' do
        subject.bid Baron::Action::Bid.new(player1, 5)
        subject.pass
        expect(subject.player).to eq player3
      end
    end
  end

  describe '#winner?' do
    subject { auction.winner? }

    context 'when more than 1 player are still active' do
      before do
        auction.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
        auction.bid Baron::Action::Bid.new(player2, Baron::Money.new(10))
        auction.bid Baron::Action::Bid.new(player3, Baron::Money.new(15))
        auction.pass
      end
      it { should be false }
    end

    context 'when only 1 player is still active' do
      context 'when someone has bid' do
        before do
          auction.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
          auction.pass
          auction.bid Baron::Action::Bid.new(player3, Baron::Money.new(10))
          auction.pass
        end
        it { should be true }
      end

      context 'when no one has bid' do
        before do
          auction.pass
          auction.pass
        end
        it { should be false }
      end
    end
  end

  describe '#current_bid' do
    subject { auction.current_bid }

    context 'when no one has bid' do
      it { should be_nil }
    end

    context 'when someone has bid' do
      let(:high_bid) { Baron::Action::Bid.new(player2, Baron::Money.new(5)) }

      before do
        auction.bid Baron::Action::Bid.new(player1, Baron::Money.new)
        auction.bid high_bid
      end

      it 'returns the highest bid' do
        should == high_bid
      end
    end
  end

  describe '#high_bidder' do
    subject { auction.high_bidder }

    context 'when no one has bid' do
      it { should be_nil }
    end

    context 'when someone has bid' do
      let(:high_bid) { Baron::Action::Bid.new(player2, Baron::Money.new(10)) }

      before do
        auction.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
        auction.bid high_bid
        auction.pass
      end

      it 'returns the person who made the highest bid so far' do
        should == player2
      end
    end
  end

  describe '#available_actions' do
    subject { auction.available_actions }

    context 'when multiple players are still in the auction' do
      it 'allows players to bid and pass' do
        should match_array [
          Baron::Action::Bid,
          Baron::Action::Pass
        ]
      end
    end

    context 'when one player is remaining in the auction' do
      before do
        auction.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
        auction.pass
        auction.pass
      end

      context 'when they have selected their certificate' do
        let(:game) do
          instance_double Baron::Game, initial_offering: initial_offering
        end

        let(:action) do
          Baron::Action::SelectCertificate.new game, player3, certificate
        end

        before { auction.select(action) }

        it { should be_empty }
      end

      context 'when they have not selected their certificate' do
        it 'allows them to select a certificate' do
          should match_array [Baron::Action::SelectCertificate]
        end
      end
    end
  end

  describe '#select' do
    let(:select_action) do
      Baron::Action::SelectCertificate.new game, player3, certificate
    end

    let(:game) do
      instance_double Baron::Game, initial_offering: initial_offering
    end

    subject { auction.select select_action }

    it 'assigns the certificate from the action' do
      subject
      expect(auction.certificate).to eq certificate
    end
  end

  describe '#certificate' do
    subject { auction.certificate }
    context 'when unassigned' do
      it { should be_nil }
    end
  end

  describe '#done?' do
    subject { auction.done? }

    context 'when the auction has finished' do
      let(:game) do
        instance_double Baron::Game, initial_offering: initial_offering
      end

      let(:action) do
        Baron::Action::SelectCertificate.new game, player3, certificate
      end

      before do
        auction.bid Baron::Action::Bid.new(player1, Baron::Money.new(5))
        auction.pass
        auction.pass
        auction.select(action)
      end

      it { should be true }
    end

    context 'when the auction has not finished' do
      it { should be false }
    end
  end
end
