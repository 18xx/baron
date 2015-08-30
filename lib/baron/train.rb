module Baron
  # A train which can be owned by a company
  #
  # Trains will be run by a company in order to earn money for itself
  # or its shareholders.
  class Train
    include Ownable
    # The type of train that this is
    #
    # @example
    #   train.type
    #
    # @api public
    # @return [Baron::TrainType] The type of this train
    attr_reader :type

    # Create the train
    #
    # @example
    #   Baron::Train.new(train_type)
    #
    # @api public
    # @param [Baron:TrainType] type
    def initialize(type)
      @type = type
    end
  end
end
