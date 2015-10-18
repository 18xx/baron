module Baron
  class Action
    # Start a new company by purchasing the directors certificate and setting
    # the par price.
    class StartCompany < self
      # Create the start company action
      #
      # @example
      #   Baron::Action::StartCompany.new(
      #     game,
      #     player,
      #     company,
      #     Baron::Money.new(100)
      #   )
      #
      # @api public
      # @param [Baron::Game] game
      # @param [Baron::Player] player
      # @param [Baron::Company] company
      # @param [Baron::Money] par_price
      def initialize(game, player, company, par_price)
        @game = game
        @player = player
        @company = company
        @par_price = par_price
      end

      # Perform the appropriate setup when the company is started
      #
      # This will set the par price of the company, tranfer the directors
      # certificate to the player who started the company (in exchange for
      # the appropriate amount of money) and make the remaining certificates
      # available.
      #
      # @api private
      # @return [void]
      def setup
        set_par_price
        make_certificates_available
        create_transaction
      end

      private

      # Create the transaction to transfer the directors certificate and money
      #
      # @api private
      # @return [Baron::Transaction]
      def create_transaction
        Transaction.new(
          @player,
          [director_certificate],
          @game.initial_offering,
          [@par_price * director_certificate.num_shares]
        )
      end

      # Move the company certificates to the initial offering
      #
      # @api private
      # @return [void]
      def make_certificates_available
        unavailable_certificates_pool.give(
          @game.initial_offering,
          unavailable_certificates_pool.certificates_for(@company)
        )
      end

      # Set the par price of the company in the market
      #
      # @api private
      # @return [void]
      def set_par_price
        @game.initial_offering.set_par_price(@company, @par_price)
        @game.market.add_company(@company, @par_price)
      end

      # The unavailable certificates pool
      #
      # @api private
      # @return [void]
      def unavailable_certificates_pool
        @game.unavailable_certificates_pool
      end

      # The directors certificate of the company to be started
      #
      # @api private
      # @return [Baron::Certificate] The directors certificate
      def director_certificate
        @game.initial_offering.certificates_for(@company).find(&:director?)
      end
    end
  end
end
