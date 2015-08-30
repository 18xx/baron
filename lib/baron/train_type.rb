module Baron
  # A type of train available for use in the game
  #
  # A TrainType will list the major attributes of the train, such as how many
  # stations it is able to count, how much it costs, and when it becomes
  # obsolete.
  class TrainType
    # The number of major stations the train can count
    #
    # The major station allowance can also be used towards minor stations
    # provided that the train runs within the restrictions of the rules.
    #
    # @example
    #   train_type.major_station_allowance
    #
    # @api public
    # @return [Fixnum]
    attr_reader :major_station_allowance

    # The number of minor stations the train can count
    #
    # @example
    #   train_type.minor_station_allowance
    #
    # @api public
    # @return [Fixnum]
    attr_reader :minor_station_allowance

    # The face value cost of this train
    #
    # @example
    #   train_type.face_value
    #
    # @api public
    # @return [Baron::Money]
    attr_reader :face_value

    # The type of train which rusts this train
    #
    # Once the first train of the type listed is sold, this train is rusted
    # and becomes obsolete. Under most rules, it can no longer be run.
    #
    # @example
    #   train_type.rusted_by
    #
    # @api public
    # @return [Baron::TrainType]
    attr_reader :rusted_by

    # Create a train type
    #
    # @example
    #   Baron::TrainType.new(
    #     2,
    #     Baron::Money.new(250),
    #     minor_station_allowance: 1,
    #     rusted_by: rusting_train_type
    #   )
    #
    # @api public
    # @param [Fixnum] major_station_allowance The number of major stations tha
    # this train may count
    # @param [Baron::Money] face_value The amount this train costs
    # @param [Fixnum] minor_station_allowance The number of minor stations that
    # this train may count
    # @param [Baron::TrainType] rusted_by The type of train that rusts this
    # train
    def initialize(
      major_station_allowance,
      face_value,
      minor_station_allowance: nil,
      rusted_by: nil
    )
      @major_station_allowance = major_station_allowance
      @minor_station_allowance = minor_station_allowance
      @face_value = face_value
      @rusted_by = rusted_by
    end

    # Return a string representation of this object
    #
    # The format of a train which has a minor station allowance will be
    # `major+minorT` such as "2+1T"
    #
    # The format of a train which does not have a minor station allowance will
    # be `majorT` such as "2T"
    #
    # @example
    #   train_type.to_s #=> '2+1T'
    #
    # @api public
    # @return [String] A string representation of the object
    def to_s
      result = major_station_allowance.to_s
      result += '+' + minor_station_allowance.to_s if minor_station_allowance
      result + 'T'
    end
  end
end
