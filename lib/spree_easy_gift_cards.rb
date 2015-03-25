require 'spree_core'
require 'spree_easy_gift_cards/engine'
require 'helpers/configuration'

module SpreeEasyGiftCards
  extend Configuration
  define_setting :auto_ship_digital_shipments, false
end
