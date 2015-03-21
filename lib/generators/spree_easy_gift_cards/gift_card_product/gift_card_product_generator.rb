module SpreeEasyGiftCards
  module Generators
    class GiftCardProductGenerator < Rails::Generators::Base
      def add_gift_card_product
        Spree::Product.create({
          sku: 'GIFTCARD',
          name: 'Gift Card',
          slug: 'gift-card',
          description: "Shopping for someone else but not sure what product they'll want? Give them the gift of choice with a Gift Card! Gift cards are delivered by email and contain instructions to redeem them at checkout. \r\n\r\nDisclaimer: Make sure the receiver of this gift card is checking their email! Your gift could be hiding in their junk folder!",
          price: gift_card_prices.first,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Default')
        })
      end

      def add_gift_card_variants
        gift_card_variants = []
        gift_card_prices.each do |price|
          gift_card_variants << {sku: "GIFTCARD-#{price}", price: price}
        end
        gift_card_product.variants.create(gift_card_variants)
      end

      def add_gift_card_to_product
        gift_card_product.create_gift_card
      end

      private
        def gift_card_product
          Spree::Product.find_by(slug: 'gift-card')
        end

        def gift_card_prices
          [10,20,50,100,200]
        end
    end
  end
end
