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
      def initialize(game, player, certificate)
        super(player)
        @game = game
        @certificate = certificate
        Transaction.new(
          player,
          [certificate],
          @game.initial_offering,
          [certificate.company.face_value]
        )
      end
    end
  end
end
