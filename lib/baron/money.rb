module Baron
  # Money is a fundamental concept in 18xx. It is used to pay for shares,
  # trains, track, token placement, and more.
  #
  # The winner of an 18xx game is the player who has highest value at the end
  # whish is the sum of the money they have, plus the monetary value of shares
  # they own.
  class Money
    include Comparable

    # The amount of money
    #
    # @example
    #   money.amount
    #
    # @api public
    # @return [Fixnum]
    attr_reader :amount

    # Initialize the money object
    #
    # @example
    #   Baron::Money.new(10)
    #
    # @api public
    # @param [Fixnum] amount
    def initialize(amount = 0)
      @amount = amount
    end

    # Adds two moneys together and returns a new money with the summed value
    #
    # @example
    #   Baron::Money.new(10) + Baron::Money.new(2) #=> Baron::Money.new(12)
    #
    # @api public
    # @param [Baron::Money] other
    # @return [Baron::Money]
    def +(other)
      Money.new(amount + other.amount)
    end

    # Subtracts one money from another returns a new money with the summed value
    #
    # @example
    #   Baron::Money.new(10) - Baron::Money.new(2) #=> Baron::Money.new(8)
    #
    # @api public
    # @param [Baron::Money] other
    # @return [Baron::Money]
    def -(other)
      Money.new(amount - other.amount)
    end

    # Compares the money amounts
    #
    # @example
    #   Baron::Money.new(10) > Baron::Money.new(5) #=> true
    #
    # @api public
    # @param [Baron::Money] other
    # @return [Fixnum] Returns 1 if this object is greater, -1 if the other
    # object in is greater, 0 if they are equal, and nil if they are not
    # comparable
    def <=>(other)
      amount <=> other.amount
    end

    # Convert the money to a a string
    #
    # @example
    #   Baron::Money.new(10).to_str #=> '$10'
    #
    # @api public
    # @return [String] The string representation of this money
    def to_s
      "$#{amount}"
    end
  end
end
