# frozen_string_literal: true
module Baron
  # A company represents one of the sets of railroad companies which exist
  # in the game, including Private, Minor, and Major railroad companies
  class Company
    include Shareholder

    # The short abbreviation for the company
    #
    # @example
    #   company.abbreviation #=> 'LNWR'
    #
    # @api public
    # @return [String]
    attr_reader :abbreviation

    # The full name of the company
    #
    # @example
    #   company.abbreviation #=> 'London and North Western Railway'
    #
    # @api public
    # @return [String]
    attr_reader :name

    # Initialize the Company
    #
    # @example
    #   Baron::Company::MajorCompany.new('CPR', 'Canadian Pacific Railway')
    #
    # @api public
    # @param [String] abbreviation
    # @param [String] name
    def initialize(abbreviation, name)
      @name = name
      @abbreviation = abbreviation
    end

    # Convert the company to a string containing their abbreviation
    #
    # @example
    #  company.to_s #=> 'CPR'
    #
    # @api public
    # @return [String]
    def to_s
      abbreviation
    end

    # The face value of this company
    #
    # Most companies do not have a face value, but some types do and they should
    # implement this and set the value to a non-nil value.
    #
    # @example
    #   company.face_value #=> nil
    #
    # @api public
    # @return [Baron::Money] The amount of its face value, or nil.
    def face_value
    end
  end
end
