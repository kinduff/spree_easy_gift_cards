module SpreeEasyGiftCards
  module Generators
    class GiftCardProductGenerator < Rails::Generators::Base
      def destroy_first
        Spree::ShippingCategory.find_by(name: 'Not Shippable').try(:destroy)
        Spree::ShippingMethod.find_by(admin_name: 'Digital').try(:destroy)
        gift_card_product.try(:destroy)
      end

      def add_shipping_configurations
        shipping_category = Spree::ShippingCategory.create(name: 'Not Shippable')
        shipping_method = Spree::ShippingMethod.new(name: 'Send by email', admin_name: 'Digital')
        shipping_method.build_calculator(type: "Spree::Calculator::Shipping::FlatRate")
        shipping_method.shipping_categories << shipping_category
        shipping_method.zones << Spree::Zone.all
        shipping_method.save
      end

      def add_gift_card_product
        Spree::Product.create({
          sku: 'GIFTCARD',
          name: 'Gift Card',
          slug: 'gift-card',
          description: "Shopping for someone else but not sure what product they'll want? Give them the gift of choice with a Gift Card! Gift cards are delivered by email and contain instructions to redeem them at checkout. \r\n\r\nDisclaimer: Make sure the receiver of this gift card is checking their email! Your gift could be hiding in their junk folder!",
          price: gift_card_prices.first,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Not Shippable'),
          available_on: Date.today
        })
      end

      def add_gift_card_variants
        gift_card_variants = []
        gift_card_prices.each do |price|
          gift_card_variants << {sku: "GIFTCARD-#{price}", price: price, track_inventory: false}
        end
        gift_card_product.variants.create(gift_card_variants)
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
