SpreeEasyGiftCards.configuration do |config|
  # ==> Gift Card Product
  # The product.gift_card? method is going to compare this value to see if it's a gift card
  # or not. The intention was to avoid adding a new field/table to the database.
  config.gift_card_product = 'gift-card'

  # ==> Gift Card code length
  # Uses Digest::SHA2 encryption by default, set your desire code length between 1 and 64
  config.code_length = 30
  
  # ==> Gift Card frontend fields
  # Gift card fields the user is going to personalize. First key is the default field name.
  # Inner hash accepts mandatory tag type for the input tag.
  # Accepts same options as content_tag + label_tag for :label key
  config.fields = {
    :recipient_name => {
      :label => 'Recipient name',
      :tag => 'input',
      :options => {
        :type => 'text',
        :required => true,
        :class => 'form-control'
      }
    },
    :recipient_email => {
      :label => 'Recipient email',
      :tag => 'input',
      :options => {
        :type => 'email',
        :required => true,
        :class => 'form-control'
      }
    },
    :message => {
      :label => 'Message',
      :tag => 'textarea',
      :options => {
        :required => true,
        :class => 'form-control'
      }
    }
  }

  # ==> Auto Ship Digital Shipments when transition to Ready
  # Sends and activates gift cards inside order when shipment is ready, default is false
  config.auto_ship_digital_shipments = false
end
