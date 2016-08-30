# frozen_string_literal: true
module Baron
  # Ownable is a class to list the types of things that can be owned by a
  # player or corporation
  module Ownable
    include Transferrable

    # Add this ownable items to the list of owners
    #
    # @api private
    # @param [Baron::Shareholder] owner
    # @return [void]
    def owner=(owner)
      @owners ||= []
      @owners << owner
    end

    # Return the current owner of this ownable
    #
    # @api private
    # @return [Baron::Shareholder] The shareholder who currently owns this,
    # item, nil if it is not owned by anyone
    def owner
      defined?(@owners) && @owners.last
    end

    # Validate that the shareholder specified is the owner of this object
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @return [void]
    def validate_owner(shareholder)
      fail(
        NotOwnerError,
        "#{shareholder} attempted to sell item owned by #{owner}"
      ) unless owner.equal?(shareholder)
    end

    # Items must be tranferrable to be involved in a transaction
    class NotOwnerError < StandardError
    end
  end
end
