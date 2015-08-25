module Baron
  class Round
    # An operating round in the game
    #
    # In the operating round, each company (private, minor, and major) gets
    # an operation which may include an opportunity to lay tiles, purchase
    # tokens, run trains, and buy trains.
    class OperatingRound < self
      # Create the operating round
      #
      # @example
      #   Baron::OperatingRound.new(game)
      #
      # @api public
      # @param [Baron::Game] game
      def initialize(game)
        @game = game
        pay_privates
      end

      private

      # Pay out all private companies
      #
      # @api private
      # @return [void]
      def pay_privates
        @game.players.each do |player|
          player.private_certificates.each do |private_cert|
            @game.bank.give player, private_cert.company.revenue
          end
        end
      end
    end
  end
end
