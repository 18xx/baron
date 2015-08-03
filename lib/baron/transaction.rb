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
    IS_CERTIFICATE = -> (item) { item.instance_of? Certificate }

    # One of the parties participating in the transacion, labelled as the buyer
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.buyer #=> buyer
    #
    # @api public
    # @return [Object]
    attr_reader :buyer

    # The items the buyer is receiving
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.buyer_items #=> buyer_items
    #
    # @api public
    # @return [Array<Object>]
    attr_reader :buyer_items

    # The second party participating in the transaction, labelled as the seller
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.seller #=> seller
    #
    # @api public
    # @return [Object]
    attr_reader :seller

    # The items the seller is receiving
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.seller_items #=> seller_items
    #
    # @api public
    # @return [Array<Object>]
    attr_reader :seller_items

    # Initialize the object
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #
    # @api public
    # @param [Object] buyer
    # @param [Array<Object>] buyer_items
    # @param [Object] seller
    # @param [Array<Object>] seller_items
    def initialize(buyer, buyer_items, seller, seller_items)
      @buyer = buyer
      @buyer_items = buyer_items
      @seller = seller
      @seller_items = seller_items

      validate_items

      @buyer.add_transaction self
      @seller.add_transaction self if @seller
    end

    # The items which the shareholder transferred away
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.debits(buyer) #=> seller_items
    #
    # @api public
    # @param [Shareholder] shareholder
    # @return [Array<Object>] The objects transferred away
    def debits(shareholder)
      shareholder_effects(shareholder, :debit)
    end

    # The items which the shareholder received
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.credits(buyer) #=> buyuer_items
    #
    # @api public
    # @param [Shareholder] shareholder
    # @return [Array<Object>] The objects receieved
    def credits(shareholder)
      shareholder_effects(shareholder, :credit)
    end

    # The certificates the shareholder receieves in this transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @return [Array<Baron::Certificate>]
    def incoming_certificates(shareholder)
      shareholder_effects(shareholder, :credit).select(&IS_CERTIFICATE)
    end

    # The certificates the shareholder loses in this transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @return [Array<Baron::Certificate>]
    def outgoing_certificates(shareholder)
      shareholder_effects(shareholder, :debit).select(&IS_CERTIFICATE)
    end

    private

    # Return the items that changed hands for the type and shareholder
    #
    # The items the shareholder was debited if type is :debit, or credited
    # if type is :credit
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @param [Symbol] type Either :debit or :credit
    # @return [Array<Object>] The objects transferred
    def shareholder_effects(shareholder, type)
      validate(shareholder)
      effects.fetch(shareholder).fetch(type)
    end

    # Return a hash explaining the effects of this transaction
    #
    # The hash format is as follows:
    # {
    #   buyer => {
    #     :debit => {the items the buyer gave up},
    #     :credit => {the items the buyer received}
    #   },
    #   seller => {
    #     :debit => {the items the seller gave up},
    #     :credit => {the items the seller received}
    #   }
    # }
    #
    # @api private
    # @return [Hash] The effects for buyer and seller
    def effects
      {
        buyer => { debit: seller_items, credit: buyer_items },
        seller => { debit: buyer_items, credit: seller_items }
      }
    end

    # Validate that the shareholder is a party to this transaction
    #
    # It will raise an InvalidPartyError if they are not a party to this
    # transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @return [void]
    def validate(shareholder)
      fail InvalidPartyError unless [buyer, seller].include?(shareholder)
    end

    # Validate the items are an array of items, or nil
    #
    # @api private
    # @param [Array<Object>] items
    # @return [void]
    def validate_items
      [@buyer_items, @seller_items].each do |items|
        fail InvalidItemsError unless !items || items.respond_to?(:each)
      end
    end

    # This party is not involved in the transaction
    class InvalidPartyError < StandardError
    end

    # Items must be an array, or nil
    class InvalidItemsError < StandardError
    end
  end
end
