module Baron
  module Action
    # The error is raised when a player attempts to take a turn, however it
    # is not that players turn.
    class NotPlayersTurn < StandardError
    end
  end
end
