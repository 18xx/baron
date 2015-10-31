module Baron
  # The bank represents the source of money for turns and other financial
  # aspects of the company. It can hold money, company shares (in the bank pool)
  # trains, and more.
  class Bank
    include Shareholder

    # The game this bank belongs to
    #
    # @example
    #   bank.game
    #
    # @api public
    # @return [Baron::Game]
    attr_reader :game

    # Initialize the bank
    #
    # @example
    #   Baron::Bank.initialize(game)
    #
    # @api public
    # @param [Baron::Game] game
    def initialize(game)
      @game = game
    end

    # The cost of the certificate based on current market price
    #
    # The cost of the certificate is the market price times the number
    # of shares that the certificate is for.
    #
    # @example
    #   @bank.cost(certificate) #=> Baron::Money.new(68)
    #
    # @api public
    # @param [Baron::Certificate] certificate
    # @return [Baron::Money]
    def cost(certificate)
      certificate.market_cost(@game.market)
    end

    # Return a string representation of the bank
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::Bank:#{object_id}>"
    end
  end
end
