require 'spree_core'
require 'spree_easy_gift_cards/engine'
require 'helpers/configuration'

module SpreeEasyGiftCards
  extend Configuration
  define_setting :auto_ship_digital_shipments, false
  define_setting :fields, {
    :recipient_name => {
      :label => "Recipient name",
      :tag => 'input',
      :options => {
        :type => "text",
        :required => true,
        :value => "Alejandro AR"
      }
    },
    :recipient_email => {
      :label => "Recipient email",
      :tag => 'input',
      :options => {
        :type => "email",
        :required => true,
        :value => "abarcadabra@gmail.com"
      }
    },
    :message => {
      :label => "Message",
      :tag => "textarea",
      :options => {
        :required => true,
        :content => "Lorem Ipsum Dolor sit amet"
      }
    }
  }
  define_setting :gift_card_product, 'gift-card'
end
