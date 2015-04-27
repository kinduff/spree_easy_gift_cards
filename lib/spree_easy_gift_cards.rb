require 'spree_core'
require 'spree_easy_gift_cards/engine'
require 'helpers/configuration'
module SpreeEasyGiftCards
  extend Configuration
  define_setting :auto_ship_digital_shipments, false
  define_setting :fields, {
    :recipient_name => {
      :label => 'Recipient name',
      :tag => 'input',
      :options => {
        :type => 'text',
        :required => true,
        :value => 'Quentin Tarantino',
        :class => 'form-control'
      }
    },
    :recipient_email => {
      :label => 'Recipient email',
      :tag => 'input',
      :options => {
        :type => 'email',
        :required => true,
        :value => 'kill@bill.com',
        :class => 'form-control'
      }
    },
    :message => {
      :label => 'Message',
      :tag => 'textarea',
      :content_or_options_with_block => 'The less a man makes declarative statements, the less apt he is to look foolish in retrospect.',
      :options => {
        :required => true,
        :class => 'form-control'
      }
    }
  }
  define_setting :gift_card_product, 'gift-card'
  define_setting :code_length, 30
end
