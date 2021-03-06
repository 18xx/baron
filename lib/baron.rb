# frozen_string_literal: true
require 'bigdecimal'
require 'yaml'

# Baron Top Level Library
module Baron
end

require 'baron/shareholder'
require 'baron/transferrable'
require 'baron/ownable'

require 'baron/action'
require 'baron/action/company_action'
require 'baron/action/bid'
require 'baron/action/buy_certificate'
require 'baron/action/buy_train'
require 'baron/action/done'
require 'baron/action/illegal_bid_amount'
require 'baron/action/pass'
require 'baron/action/payout'
require 'baron/action/place_tile'
require 'baron/action/place_token'
require 'baron/action/retain'
require 'baron/action/run_trains'
require 'baron/action/select_certificate'
require 'baron/action/sell_certificates'
require 'baron/action/start_company'

require 'baron/bank'

require 'baron/company'
require 'baron/company/private_company'
require 'baron/company/major_company'

require 'baron/certificate'
require 'baron/initial_offering'
require 'baron/game'
require 'baron/game_round_flow'
require 'baron/market'
require 'baron/money'

require 'baron/player'

require 'baron/round'
require 'baron/round/initial_auction'
require 'baron/round/operating_round'
require 'baron/round/round_not_over'
require 'baron/round/stock_round'

require 'baron/rules'
require 'baron/train'
require 'baron/train_type'
require 'baron/transaction'
require 'baron/transferrable'

require 'baron/turn'
require 'baron/turn/operating_turn'
require 'baron/turn/stock_turn'
require 'baron/turn/winner_choose_auction'
require 'baron/turn/wrong_turn'

require 'baron/unavailable_certificates_pool'
