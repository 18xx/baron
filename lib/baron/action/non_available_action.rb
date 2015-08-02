module Baron
  class Action
    # This error is thrown when a player attempts to perform a non-available
    # action.
    class NonAvailableAction < StandardError
    end
  end
end
