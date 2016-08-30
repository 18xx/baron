# frozen_string_literal: true
module Baron
  class Action
    # Error raised when the player has not bid a legal amount
    class IllegalBidAmount < StandardError
    end
  end
end
