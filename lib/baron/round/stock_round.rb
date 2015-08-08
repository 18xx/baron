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
      def initialize(game)
        @game = game
        @unavailable_certificates_pool = game.unavailable_certificates_pool
        make_directorships_available
        make_shares_available
      end

      private

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
          ) if @game.director(cert.company)
        end
      end
    end
  end
end
