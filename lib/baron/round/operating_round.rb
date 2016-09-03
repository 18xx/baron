# frozen_string_literal: true
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
        set_turn_order
      end

      # The current stock turn of a player taking their actions
      #
      # @example
      #   round.current_turn
      #
      # @api public
      # @return [Baron::Turn::StockTurn]
      def current_turn
        @current_turn = @turn_order.shift if @current_turn.done?
        @current_turn
      end

      # Is the current round over?
      #
      # The operating round ends when all companies have taken turns
      #
      # @example
      #   round.over?
      #
      # @api public
      # @return [Boolean] True if the round is over, false otherwise
      def over?
        !current_turn
      end

      # Start the round and execute any special rules
      #
      # This pays out private companies at the start of every operating round
      #
      # @example
      #   round.start
      #
      # @api public
      # @return [void]
      def start
        pay_privates
      end

      private

      # Pay out all private companies
      #
      # @api private
      # @return [void]
      def pay_privates
        game.players.each do |player|
          player.private_certificates.each do |private_cert|
            game.bank.give player, private_cert.company.revenue
          end
        end
      end

      # The operating order for the companies this round
      #
      # @api private
      # @return [Array<Baron::Company>] A sorted array with the companies that
      # will operate in the order that they will operate
      def operating_order
        game.market.operating_order
      end

      # Sets up the turn order for the round
      #
      # @api private
      # @return [void]
      def set_turn_order
        @turn_order = operating_order.map do |company|
          Turn::OperatingTurn.new(
            game,
            game.director(company),
            company
          )
        end
        @current_turn = @turn_order.shift
      end
    end
  end
end
