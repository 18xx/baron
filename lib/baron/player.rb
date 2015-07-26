module Baron
  # A partipant in a game
  class Player
    include Shareholder

    # The player's name
    #
    # @return [String]
    attr_reader :name

    # The player's position in the game
    #
    # @return [Fixnum]
    attr_accessor :position

    # Initialize the player object
    #
    # @param [String] name
    def initialize(name)
      @name = name
    end

    # Convert the player object to a string
    #
    # @return [String]
    def to_s
      name
    end
  end
end
