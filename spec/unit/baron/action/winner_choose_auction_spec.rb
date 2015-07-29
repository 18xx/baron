RSpec.describe Baron::Action::WinnerChooseAuction do
  let(:player1) { double Baron::Player, to_s: 'Bart' }
  let(:player2) { double Baron::Player, to_s: 'Lisa' }
  let(:player3) { double Baron::Player, to_s: 'Maggie' }

  let(:players) { [player1, player2, player3] }

  let(:auction) { described_class.new(players) }

  subject { auction }

  let(:bid) { Baron::Action::Bid.new(bid_player, bid_amount) }
  let(:bid_player) { player1 }
  let(:bid_amount) { 10 }

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
        expect(subject.current_player).to eq(player2)
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
      let(:new_bid) { Baron::Action::Bid.new(player2, 5) }

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
      let(:bid_amount) { 5 }
      let(:new_bid) { Baron::Action::Bid.new(player2, 5) }

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
          Baron::Action::WrongTurn,
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
  end

  describe '#current_player' do
    context 'when no one has acted' do
      it 'is the first player' do
        expect(subject.current_player).to eq player1
      end
    end

    context 'when some players have bid' do
      it 'is the next player in order' do
        subject.bid Baron::Action::Bid.new(player1, 5)
        subject.pass
        expect(subject.current_player).to eq player3
      end
    end
  end

  describe '#done?' do
    subject { auction.done? }

    context 'when more than 1 player are still active' do
      before do
        auction.bid Baron::Action::Bid.new(player1, 5)
        auction.bid Baron::Action::Bid.new(player2, 10)
        auction.bid Baron::Action::Bid.new(player3, 15)
        auction.pass
      end
      it { should be false }
    end

    context 'when only 1 player is still active' do
      before do
        auction.bid Baron::Action::Bid.new(player1, 5)
        auction.pass
        auction.bid Baron::Action::Bid.new(player3, 10)
        auction.pass
      end
      it { should be true }
    end
  end

  describe '#current_bid' do
    subject { auction.current_bid }

    context 'when no one has bid' do
      it { should be_nil }
    end

    context 'when someone has bid' do
      let(:high_bid) { Baron::Action::Bid.new(player2, 5) }

      before do
        auction.bid Baron::Action::Bid.new(player1, 0)
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
      let(:high_bid) { Baron::Action::Bid.new(player2, 10) }

      before do
        auction.bid Baron::Action::Bid.new(player1, 5)
        auction.bid high_bid
        auction.pass
      end

      it 'returns the person who made the highest bid so far' do
        should == player2
      end
    end
  end
end
