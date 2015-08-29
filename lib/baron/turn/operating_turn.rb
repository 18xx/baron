module Baron
  class Turn
    # An operating turn is taken by the director on behalf of a company
    #
    # Each company will generally get one turn during each operating round
    # during which they may:
    # - Lay tiles
    # - Place Tokens
    # - Run Trains
    # - Purchase Trains
    # and more
    class OperatingTurn < self
      # The company performing this operation
      #
      # @example
      #   turn.company
      #
      # @api public
      # @return [Baron::Company]
      attr_reader :company

      # The director in charge of this operation
      #
      # @example
      #   turn.director
      #
      # @api public
      # @return [Baron::Player]
      attr_reader :director

      # Initialize the operating turn
      #
      # @example
      #   Baron::Turn::OperatingTurn.new(company)
      #
      # @api public
      # @param [Baron::Company] company
      def initialize(director, company)
        @company = company
        @director = director
      end
    end
  end
end
