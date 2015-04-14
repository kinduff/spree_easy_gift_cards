Deface::Override.new(
  name: 'gift_card description if gift card line item',
  virtual_path: 'spree/shared/_order_details',
  replace_contents: '[data-hook=order_item_description]'
) do
<<-CODE.chomp
<% if item.gift_card? %>
  <h4><%= item.variant.product.name %></h4>
  <%= gift_card_description_text(item) %>
  <%= "(" + item.variant.options_text + ")" unless item.variant.option_values.empty? %>
<% else %>
  <h4><%= item.variant.product.name %></h4>
  <%= truncated_product_description(item.variant.product) %>
  <%= "(" + item.variant.options_text + ")" unless item.variant.option_values.empty? %>
<% end %>
CODE
end
