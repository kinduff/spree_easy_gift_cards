Deface::Override.new(
  name: 'gift_card description if gift card line item',
  virtual_path: 'spree/orders/_line_item',
  replace_contents: '[data-hook=line_item_description]',
  text: "<%= line_item.gift_card? ? gift_card_description_text(line_item) : line_item_description_text(line_item.description) %>"
)
Deface::Override.new(
  name: 'disables quantity input if gift card line item',
  virtual_path: 'spree/orders/_line_item',
  replace_contents: '[data-hook=cart_item_quantity]',
  text: "<%= item_form.number_field :quantity, min: 0, class: 'form-control line_item_quantity', size: 5, disabled: line_item.gift_card? %>"
)
