# Override Rails default field_with_errors wrapper to use Bootstrap's is-invalid class
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|select|textarea|div class="trix-content")/i
    html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    
    # Add is-invalid class to input, select, and textarea elements
    html.css('input, select, textarea').each do |input|
      input['class'] = "#{input['class']} is-invalid"
    end
    
    # Handle trix editor container
    html.css('.trix-content').each do |trix|
      trix['class'] = "#{trix['class']} is-invalid"
    end
    
    html.to_s.html_safe
  else
    html_tag
  end
end