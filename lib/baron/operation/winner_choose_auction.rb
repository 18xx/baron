module Baron
  module Operation
    # This is an auction where the players bid, and the winner then chooses
    # which thing to purchase after winning.
    class WinnerChooseAuction
      # Returns the players which are sill available to partipate in the
      # auction. The first player returned in the player whose turn it currently
      # is.
      #
      # @return [Array<Baron::Player>]
      attr_reader :active_players

      # The private company the player chose after winning this auction.
      #
      # @return [Baron::Company::PrivateCompany]
      attr_reader :company

      # Initialize the auction
      #
      # @param [Array<Baron::Player>] players All players participating in this
      # auction.
      def initialize(players)
        @active_players = players
        @bids = []
      end

      # The player bids the amount in this auction. By bidding, the player
      # remains in the auction, and can win if all others players pass.
      #
      # @param [Baron::Operation:Bid] player_bid The bid being made.
      def bid(player_bid)
        validate_turn(player_bid.player)
        validate_bid(player_bid)
        @bids << player_bid
        @active_players.push @active_players.shift
      end

      # The player passes on this auction. The player can not bid again in this
      # auction and will be removed from the list of active players.
      def pass
        @active_players.shift
      end

      # The player selects a private company with their action
      #
      # @param [Baron::Operation::SelectPrivateCompany] action
      def select(action)
        @company = action.company
      end

      # Determine the current player.
      #
      # @return [Baron::Player] The player whose turn it is
      def current_player
        @active_players.first
      end

      # Is the auction over
      #
      # @return [Boolean] true if the auction is over, false otherwise
      def winner?
        @active_players.count.equal? 1
      end

      # The most recent bid in the auction. If the auction is done, then this
      # is the winning bid.
      #
      # @return [Baron::Operation::Bid] Returns the most recent bid, nil if
      # there are no bids.
      def current_bid
        @bids.last
      end

      # The player who has made the highest bid so far. If the auction is done,
      # then this is the auction winner.
      #
      # @return [Baron::Player] Returns the player who has bid the highest,
      # nil if there are no bids.
      def high_bidder
        current_bid.player if current_bid
      end

      # Return the actions that the user can perform right now
      #
      # @return [Array<Baron::Action::Base>] An array of actions the current
      # player can perform.
      def available_actions
        if @company
          []
        elsif winner?
          [Action::SelectPrivateCompany]
        else
          [Action::Bid, Action::Pass]
        end
      end

      private

      def validate_turn(player)
        fail WrongTurn, "#{player} bid, but it is " \
          "#{current_player}'s turn" unless player.equal?(current_player)
      end

      def validate_bid(bid)
        fail(
          Action::IllegalBidAmount,
          'Amount must be greater than previous bids'
        ) if current_bid && bid.amount <= current_bid.amount
      end
    end
  end
end
