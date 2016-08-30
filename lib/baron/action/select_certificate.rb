# frozen_string_literal: true
module Baron
  class Action
    # This action allows the player to select a certificate that they are
    # permitted to purchase.
    class SelectCertificate < BuyCertificate
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
        @initial_offering = game.initial_offering
        super(player, @initial_offering, certificate)
        @initial_offering.set_par_price(
          certificate.company,
          par_price
        ) if par_price
        create_transaction
      end
    end
  end
end
