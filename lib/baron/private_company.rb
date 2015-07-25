module Baron
  # A private company represents a single certificate company which can be
  # owned by a single player or company. It has a face value, and provides a
  # fixed income to the player every operating round.
  class PrivateCompany
    # The full name of the private company
    # Example: Camden & Amboy
    #
    # @return [String]
    attr_reader :name

    # The face value of the company
    #
    # @return [Fixnum]
    attr_reader :face_value

    # The recurring revenue earned every operating round during the private
    # company operating phase
    #
    # @return [Fixnum]
    attr_reader :revenue

    # Initialize the private company
    #
    # @param [Fixnum] name
    # @param [Fixnum] face_value
    # @param [Fixnum] revenue
    def initialize(name, face_value:, revenue:)
      @name = name
      @face_value = face_value
      @revenue = revenue
    end

    # Convert the company to a string containing their full name
    #
    # @return [String]
    def to_s
      name
    end
  end
end
