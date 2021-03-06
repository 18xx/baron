# frozen_string_literal: true
module Baron
  # A partipant in a game
  class Player
    include Shareholder

    # The player's name
    #
    # @example
    #   shareholder = Baron::Player::Shareholder.new('Bob')
    #   shareholder.name #=> 'Bob'
    #
    # @api public
    # @return [String]
    attr_reader :name

    # The player's position in the game
    #
    # @example
    #   shareholder.position #=> 5
    #
    # @api public
    # @return [Fixnum] The player's seating position in the game.
    attr_reader :position

    # @see class description
    #
    # @example
    #   Baron::Player::Shareholder.new('Bob')
    #
    # @api public
    # @param [String] name The player's name
    def initialize(name)
      @name = name
    end

    # Convert the player object to a string
    #
    # @example
    #   Baron::Player::Shareholder.new('Bob').to_s #=> 'Bob'
    #
    # @api public
    # @return [String] The player's name
    def to_s
      name
    end

    # Return a string representation of the player
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::Player:#{object_id} #{self}>"
    end
  end
end
