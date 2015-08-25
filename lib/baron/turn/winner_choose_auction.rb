module Baron
  class Turn
    # This is an auction where the players bid, and the winner then chooses
    # which thing to purchase after winning.
    class WinnerChooseAuction
      # Returns the players which are sill in the auction
      #
      # The first player returned in the player whose turn it currently is.
      # This array will be re-ordered as players take actions, and players
      # will be removed when they pass.
      #
      # @example
      #   auction.active_players
      #
      # @api public
      # @return [Array<Baron::Player>]
      attr_reader :active_players

      # The bank for this game
      #
      # @example
      #   game.bank
      #
      # @api public
      # @return [Baron::Bank]
      attr_reader :bank

      # The certificate the player chose after winning this auction
      #
      # @example
      #   auction.certificate
      #
      # @api public
      # @return [Baron::Certificate]
      attr_reader :certificate

      # Creates an instance of this auction
      #
      # @example
      #   Baron::Turn::WinnerChooseAuction(player_set)
      #
      # @api public
      # @param [Array<Baron::Player>] players All players participating in this
      # auction.
      def initialize(players, bank)
        @active_players = players.dup
        @bank = bank
        @bids = []
      end

      # The player bids the amount in this auction
      #
      # By bidding, the player remains in the auction, and can win if all
      # others players pass.
      #
      # @api private
      # @param [Baron::Action:Bid] action The bid being made.
      # @return [Array<Baron::Action::Bid>] All bids on this auction
      def bid(action)
        validate_turn(action.player)
        validate_bid(action)
        @active_players.push @active_players.shift
        @bids << action
      end

      # The player passes on this auction
      #
      # The player can not bid again in this auction and will be removed from
      # the list of active players.
      #
      # @api private
      # @return [void]
      def pass
        @active_players.shift
        high_bidder.give(@bank, current_bid.amount) if winner?
      end

      # The player selects a certificate with their action
      #
      # @api private
      # @param [Baron::Action::SelectCertificate] action
      # @return [Baron::Certificate] The certificate selected
      def select(action)
        @certificate = action.certificate
      end

      # Determine the current player
      #
      # @example
      #   auction.player
      #
      # @api public
      # @return [Baron::Player] The player whose turn it is
      def player
        @active_players.first
      end

      # Is there a winner of the auction
      #
      # @example
      #   auction.winner
      #
      # @api public
      # @return [Boolean] true if the auction is over, false otherwise
      def winner?
        @active_players.count.equal?(1) && @bids.any?
      end

      # The most recent bid in the auction
      #
      # If the auction is done, then this is the winning bid.
      #
      # @example
      #   auction.current_bid
      #
      # @api public
      # @return [Baron::Turn::Bid] Returns the most recent bid, nil if
      # there are no bids.
      def current_bid
        @bids.last
      end

      # The player who has made the highest bid so far
      #
      # If the auction is done then this is the auction winner.
      #
      # @example
      #   auction.high_bidder
      #
      # @api public
      # @return [Baron::Player] Returns the player who has bid the highest,
      # nil if there are no bids.
      def high_bidder
        current_bid.player if current_bid
      end

      # Return the actions that the user can perform right now
      #
      # @example
      #   auction.available_actions
      #   # returns [Baron::Action::Bid, Baron::Action::Pass]
      #
      # @api public
      # @return [Array<Baron::Action>] An array of actions the current player
      # can perform.
      def available_actions
        if certificate
          []
        elsif winner?
          [Action::SelectCertificate]
        else
          [Action::Bid, Action::Pass]
        end
      end

      # Returns true if there are no more actions that can be performed
      #
      # @example
      #   auction.done?
      #
      # @api public
      # @return [Boolean] True if this auction is complete, false otherwise
      def done?
        available_actions.empty?
      end

      private

      # Validate that is the specified player's turn
      #
      # It will throw an WrongTurn if the player specified is not the current
      # player.
      #
      # @api private
      # @param [Baron::Player] bid_player
      # @return nil
      def validate_turn(bid_player)
        fail WrongTurn, "#{bid_player} bid, but it is " \
          "#{player}'s turn" unless player.equal?(bid_player)
      end

      # Validate that this bid is legal
      #
      # It will throw an IllegalBidAmount if the bid is not greater than
      # previous bids.
      #
      # @api private
      # @return nil
      def validate_bid(bid)
        fail(
          Action::IllegalBidAmount,
          'Amount must be greater than previous bids'
        ) if current_bid && bid.amount <= current_bid.amount
      end
    end
  end
end
