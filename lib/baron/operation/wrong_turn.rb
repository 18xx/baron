module Baron
  class Operation
    # The error is raised when a player attempts to take a turn, however it
    # is not that players turn.
    class WrongTurn < StandardError
    end
  end
end
