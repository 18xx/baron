module Baron
  class Round
    # A stock round in the game
    #
    # In a stock round phase, players may generally sell many certificates in
    # to the bank pool, and then purchase a single certificate from the
    # initial offering
    class StockRound < self
      # Create the stock round
      #
      # At the start of the stock round the company will ensure that
      # directorships that belong in the initial offering are placed there.
      # It will also make any appropriate non-directors certificates available
      #
      # @example
      #   Baron::InitialAuction.new(game)
      #
      # @api public
      # @param [Baron::Game] game
      # @param [Baron::Player] priority_deal
      def initialize(game, priority_deal)
        @game = game
        @players = game.players.dup
        @players.find_index(priority_deal).times { @players.rotate! }
        @unavailable_certificates_pool = game.unavailable_certificates_pool
        @turns = []
        make_directorships_available
        make_shares_available
      end

      # The current player whose turn it is
      #
      # @example
      #   round.current_player
      #
      # @api public
      # @return [Baron::Player]
      def current_player
        current_turn.player
      end

      # The current stock turn of a player taking their actions
      #
      # @example
      #   round.current_turn
      #
      # @api public
      # @return [Baron::Turn::StockTurn]
      def current_turn
        @turns << Turn::StockTurn.new(next_player, self) if @turns.all?(&:done?)
        @turns.last
      end

      # Is the current round over?
      #
      # @example
      #   round.over?
      #
      # @api public
      # @return [Boolean]
      def over?
        num_players = @players.count
        @turns.count >= num_players &&
          @turns.last(num_players).all?(&:passed?)
      end

      # Determine who gets priority deal for the next round
      #
      # Note: This raises an error if the round is not over
      #
      # @example
      #   round.next_priority_deail
      #
      # @api public
      # @return [Baron::Player]
      def next_priority_deal
        fail RoundNotOver unless over?
        @turns.last(@players.count).first.player
      end

      private

      # The next player to take a turn
      #
      # @api private
      # @return [Baron::Player]
      def next_player
        @players.push(@players.shift).last
      end

      # Transfer directorships to the initial offering
      #
      # @api private
      # @return [void]
      def make_directorships_available
        # TODO: Make 1860 style tiered availability work
        @unavailable_certificates_pool.certificates.select(
          &:director?
        ).each do |certificate|
          @unavailable_certificates_pool.make_certificate_available(
            certificate,
            @game.initial_offering
          )
        end
      end

      # Transfers any shares for companies with directors to the offering
      #
      # @api private
      # @return [void]
      def make_shares_available
        @unavailable_certificates_pool.certificates.each do |cert|
          @unavailable_certificates_pool.make_certificate_available(
            cert,
            @game.initial_offering
          ) if @game.director(cert.company).instance_of?(Player)
        end
      end
    end
  end
end
