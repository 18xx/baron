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

      # The current operation in the game
      #
      # @example
      #   round.current_operation
      #
      # @api public
      # @return [Baron::Operation]
      def current_operation
        new_auction(ordered_players) if @current_operation.done?
        @current_operation
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

      # Creates a new auction and assigns it to the current operation
      #
      # @api private
      # @return [Baron::Operation::WinnerChooseAuction]
      def new_auction(players)
        @current_operation = Operation::WinnerChooseAuction.new(
          players, game.bank
        )
      end

      # Gets the players in order based upon the previous winner
      #
      # @api private
      # @return [Array<Baron::Player>]
      def ordered_players
        num_players = players.count
        nspi = new_starting_player_index

        num_players.times.map do |offset|
          players.fetch((offset + nspi) % num_players)
        end
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
        players.find_index(@current_operation.high_bidder) + 1
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
          game.unavailable_certificates_pool.make_available(
            company,
            game.initial_offering
          )
        end
      end
    end
  end
end
