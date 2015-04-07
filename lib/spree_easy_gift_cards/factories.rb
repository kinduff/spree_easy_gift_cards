FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    data {
      {
        recipient_name: "Quentin Tarantino",
        recipient_email: "kill@bill.com",
        message: "The less a man makes declarative statements, the less apt he is to look foolish in retrospect."
      }
    }
    line_item
  end
end
