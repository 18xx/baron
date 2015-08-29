module Baron
  class Action
    # This action is where a company places a tile on the board
    #
    # The tile is places in a hex with a specific orientation. This placement
    # can be either a standard placement of a yellow tile, or an upgrade
    # of an existing tile to another tile.
    #
    # TODO: Implement map interaction
    # TODO: Make tile, hex, and orentation objects
    class PlaceTile < CompanyAction
      # The turn that this action is a part of
      #
      # @example
      #   action.turn
      #
      # @api public
      # @return [Baron::Turn]
      attr_reader :turn

      # The tile being placed
      #
      # @example
      #   action.tile
      #
      # @api public
      # @return [String]
      attr_reader :tile

      # The hex the tile is being placed
      #
      # @example
      #   action.hex
      #
      # @api public
      # @return [String]
      attr_reader :hex

      # The orientation that the tile is being placed in
      #
      # @example
      #   action.orientation
      #
      # @api public
      # @return [String]
      attr_reader :orientation

      # Create the place tile action
      #
      # @example
      #   Baron::Action::PlaceTile(action, tile, hex, orientation)
      #
      # @api public
      # @param [Baron::Turn] turn The turn this action is a part of
      # @param [String] tile Tile number
      # @param [String] hex Hex location
      # @param [String] orientaiton The orientation number
      def initialize(turn, tile, hex, orientation)
        @turn = turn
        @tile = tile
        @hex = hex
        @orientation = orientation
      end
    end
  end
end
