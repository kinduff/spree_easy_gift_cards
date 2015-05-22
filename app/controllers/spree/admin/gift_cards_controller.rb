module Spree
  module Admin
    class GiftCardsController < ResourceController
      def index
        @collection = Spree::GiftCard.order('created_at DESC').page(params[:page]).per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def new
      end

      def create
        @gift_card = Spree::GiftCard.new(gift_card_params)
        raise @gift_card.inspect
      end

      def edit
      end

      def update
        raise params.inspect
      end

      def destroy
        @gift_card.destroy

        flash[:success] = Spree.t('notice_messages.gift_card_deleted')

        respond_with(@gift_card) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      private
        def load_gift_card
          @gift_card = GiftCard.friendly.find(params[:id])
          authorize! action, @gift_card
        end

        def gift_card_params
          params.require(:gift_card).permit(:code, :data => [SpreeEasyGiftCards.fields.keys])
        end
    end
  end
end
