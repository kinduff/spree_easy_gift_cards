Deface::Override.new(
  name: 'gift_card_form if product is gift card',
  virtual_path: 'spree/products/show',
  replace_contents: '[data-hook=cart_form]',
  text: "<%= render @product.gift_card? ? 'gift_card_form' : 'cart_form' %>"
)
