Spree::BaseHelper.class_eval do
  def gift_card_description_text line_item
    description = line_item.gift_card.data.map{|key, val|"<p><b>#{key.to_s.humanize}:</b> #{val}</p>"}.join
    sanitize description, :tags => %w[p b]
  end
end
