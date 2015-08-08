module Baron
  # Transferrable is a type of thing which can be tranferred as part of a
  # Baron::Transaction
  module Transferrable
    # Validate that the shareholder specified is the owner of this object
    #
    # This is designed to be overridden by objects which provide more strict
    # validation on ownership
    #
    # @api private
    # @param [Baron::Shareholder] _
    # @return [void]
    def validate_owner(_)
    end
  end
end
