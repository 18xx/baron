module Baron
  class Action
    # This action is where a company places a tile on the board
    #
    # The tile is places in a hex with a specific orientation. This placement
    # can be either a standard placement of a yellow tile, or an upgrade
    # of an existing tile to another tile.
    #
    # TODO: Implement map interaction
    # TODO: Make hex, an objects
    class PlaceToken < CompanyAction
      # The hex the tile is being placed
      #
      # @example
      #   action.hex
      #
      # @api public
      # @return [String]
      attr_reader :hex

      # Create the place tile action
      #
      # @example
      #   Baron::Action::PlaceTile(action, tile, hex, orientation)
      #
      # @api public
      # @param [Baron::Turn] turn The turn this action is a part of
      # @param [String] hex Hex location
      def initialize(turn, hex)
        super(turn)
        @hex = hex
      end
    end
  end
end
