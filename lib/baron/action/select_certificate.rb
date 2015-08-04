module Baron
  class Action
    # This action allows the player to select a certificate that they are
    # permitted to purchase.
    class SelectCertificate < self
      # The certifiate the player has selected
      #
      # @example
      #   action.certificate
      #
      # @api public
      # @return [Baraon::Certificate]
      attr_reader :certificate

      # Create the action where the player is selecting the certificate
      #
      # @example
      #   Baron::Action::SelectCertificate.new(
      #     player,
      #     certificate
      #   )
      # @api public
      # @param [Baron::Game] game
      # @param [Baron::Player] player The player acting
      # @param [Baron::Certificate] certificate The certifiate the player has
      # chosen to purchase.
      # @param [Baron::Money] par_price The par price for the major company
      # that this person has selected.
      def initialize(game, player, certificate, par_price = nil)
        super(player)
        @initial_offering = game.initial_offering
        @certificate = certificate
        @initial_offering.set_par_price(
          certificate.company,
          par_price
        ) if par_price
        create_transaction
      end

      private

      # Create a transaction to trasnfer the goods
      #
      # It will transfer the certificate from the initial offering to the
      # player and the funds from the player to the initial offering.
      #
      # @api private
      # @return [void]
      def create_transaction
        Transaction.new(
          @player,
          [@certificate],
          @initial_offering,
          [@initial_offering.cost(certificate)]
        )
      end
    end
  end
end
