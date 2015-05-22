Deface::Override.new(
  name: 'adds gift card entry in main menu',
  virtual_path: 'spree/layouts/admin',
  insert_bottom: '#main-sidebar',
) do
<<-CODE.chomp
<% if can? :admin, Spree::GiftCard %>
  <ul class="nav nav-sidebar">
    <%= tab :gift_cards, icon: "unchecked" %>
  </ul>
<% end %>
CODE
end
