require 'spec_helper'

describe Spree.user_class, :type => :model do
  let(:user) { create :user }
  let(:gift_card) { create :gift_card, user: user }

  it "has many gift cards" do
    expect(user.gift_cards).to eq([gift_card])
  end
end
