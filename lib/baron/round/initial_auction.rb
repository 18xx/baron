module Baron
  class Round
    # The initial auction round of the game
    #
    # This is the phase of the game in which private companies are generally
    # distributed, sometimes also containing directorships of companies.
    class InitialAuction < self
      # Create the initial auction round
      #
      # @example
      #   Baron::InitialAuction.new(game)
      #
      # @api public
      # @param [Baron::Game] game
      def initialize(game)
        @game = game
        make_auctionable_companies_available
        new_auction(game.players)
      end

      # The current turn in the game
      #
      # @example
      #   round.current_turn
      #
      # @api public
      # @return [Baron::Turn]
      def current_turn
        new_auction(ordered_players) if @current_turn.done?
        @current_turn
      end

      # Returns whether the round is over
      #
      # This will return true if there are no certificates remaining to be
      # auctioned, and false otherwise.
      #
      # @example
      #   round.over?
      #
      # @api public
      # @return [Boolean] True if the round is over, false otherwise
      def over?
        game.initial_offering.certificates.empty?
      end

      private

      # Returns the players for the game
      #
      # @api private
      # @return [Array<Baron::Player>]
      def players
        game.players
      end

      # Creates a new auction and assigns it to the current turn
      #
      # @api private
      # @return [Baron::Turn::WinnerChooseAuction]
      def new_auction(players)
        @current_turn = Turn::WinnerChooseAuction.new(
          players, game.bank
        )
      end

      # Gets the players in order based upon the previous winner
      #
      # @api private
      # @return [Array<Baron::Player>]
      def ordered_players
        arr = players.dup
        new_starting_player_index.times do
          arr.rotate!
        end
        arr
      end

      # The index in players of the new starting player
      #
      # This assumes that the array has been cycled, so with 3 players in the
      # list an index of 3 may be returned to indicate the current first
      # player starts again.
      #
      # @api private
      # @return [Fixnum]
      def new_starting_player_index
        players.find_index(@current_turn.high_bidder) + 1
      end

      private

      # The companies which are available to be auctioned
      #
      # @api private
      # @return [Array<Baron::Company>]
      def auctionable_companies
        game.rules.auctionable_companies
      end

      # Transfer auctionable companies to the initial offering
      #
      # @api private
      # @return [void]
      def make_auctionable_companies_available
        auctionable_companies.each do |company|
          game.unavailable_certificates_pool.make_company_available(
            company,
            game.initial_offering
          )
        end
      end
    end
  end
end
