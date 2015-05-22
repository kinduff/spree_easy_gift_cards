require 'spec_helper'

RSpec.describe Spree::Admin::GiftCardsController, type: :controller do
  stub_authorization!

  describe "GET index" do
    it "assigns @gift_cards" do
      gift_card = create :gift_card
      spree_get :index
      expect(assigns(:gift_cards)).to eq([gift_card])
    end

    it "renders the index template" do
      spree_get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET new" do
    it "renders the new template" do
      spree_get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
  end

  describe "GET edit" do
    it "renders the edit template" do
      gift_card = create :gift_card
      spree_get :edit, id: gift_card.id
      expect(response).to render_template("edit")
    end
  end

  describe "PUT edit" do
  end

  describe "DELETE destroy" do
  end
end
