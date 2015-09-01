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

    # The face value cost of this train
    #
    # @example
    #   train.face_value
    #
    # @see Baron::TrainType#face_value
    # @api public
    # @return [Baron::Money]
    def face_value
      type.face_value
    end
  end
end
