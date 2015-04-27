Spree::BaseHelper.class_eval do
  def gift_card_description_text line_item
    description = line_item.gift_card.data.map{|key, val|"<p><b>#{key.to_s.humanize}:</b> #{val}</p>"}.join
    sanitize description, :tags => %w[p b]
  end

  def gift_card_fields(field, attributes)
    capture do
      concat label_tag("options_gift_card_#{field}", attributes[:label]) if attributes[:label]
      concat content_tag(attributes[:tag], attributes[:content_or_options_with_block], ({ name: 'options[gift_card]['+field.to_s+']' }.merge(attributes[:options] || {}) ) )
    end
  end
end
