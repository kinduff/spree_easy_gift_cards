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
  # Inner hash accepts mandatory label and tag type for the input tag.
  # Inside options you can add any HTML attributes options you need.
  # The recipient_email key tag is highly recommended since is the recipient email we're
  # going to send the gift card by default.
  config.fields = {
    :recipient_name => {
      :label => "Recipient name",
      :tag => 'input',
      :options => {
        :type => "text",
        :required => true
      }
    },
    :recipient_email => {
      :label => "Recipient email",
      :tag => 'input',
      :options => {
        :type => "email",
        :required => true
      }
    },
    :message => {
      :label => "Message",
      :tag => "textarea",
      :options => {
        :required => true
      }
    }
  }

  # ==> Auto Ship Digital Shipments when transition to Ready
  # Sends and activates gift cards inside order when shipment is ready, default is false
  config.auto_ship_digital_shipments = false
end
