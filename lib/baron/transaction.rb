module Baron
  # A transaction is the exchange of money, trains, certificates, or other
  # purchasable items between two parties.
  #
  # The parties involved in the transaction could be the players, companies,
  # the bank pool, the initial offering, or other concepts in the game.
  #
  # The transaction will have a buyer, and a seller. The buyer receives the
  # buyer items and the seller receives the seller items.
  #
  # The names buyer and seller are not important to the transaction, but merely
  # a convenient metaphor as these actions usually involve cash.
  class Transaction
    # One of the parties participating in the transacion, labelled as the buyer
    #
    # @return [Object]
    attr_reader :buyer

    # The items the buyer is receiving
    #
    # @return [Array<Object>]
    attr_reader :buyer_items

    # The second party participating in the transaction, labelled as the seller
    #
    # @return [Object]
    attr_reader :seller

    # The items the seller is receiving
    #
    # @return [Array<Object>]
    attr_reader :seller_items

    # Initialize the object
    #
    # @param [Object] buyer
    # @param [Array<Object>] buyer_items
    # @param [Object] seller
    # @param [Array<Object>] seller_items
    def initialize(buyer, buyer_items, seller, seller_items)
      @buyer = buyer
      @buyer_items = buyer_items
      @seller = seller
      @seller_items = seller_items
    end

    # The items which the shareholder transferred away
    #
    # @params [Shareholder] shareholder
    # @returns [Array<Object>] The objects transferred away
    def debits(shareholder)
      shareholder_effects(shareholder, :debit)
    end

    # The items which the shareholder received
    #
    # @params [Shareholder] shareholder
    # @returns [Array<Object>] The objects receieved
    def credits(shareholder)
      shareholder_effects(shareholder, :credit)
    end

    private

    def shareholder_effects(shareholder, type)
      validate(shareholder)
      effects.fetch(shareholder).fetch(type)
    end

    def effects
      {
        buyer => { debit: seller_items, credit: buyer_items },
        seller => { debit: buyer_items, credit: seller_items }
      }
    end

    def validate(shareholder)
      fail InvalidPartyError unless [buyer, seller].include?(shareholder)
    end

    # This party is not involved in the transaction
    class InvalidPartyError < StandardError
    end
  end
end
