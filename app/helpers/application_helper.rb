module ApplicationHelper
require 'uri'

def convert_url_into_a_tag(text)
  text.gsub(URI.regexp(['http', 'https'])) do |text|
    "<object><a href='#{text}'>#{text}</a></object>"
  end
end

  def date_format(datetime)
    time_ago_in_words(datetime) + '前'
  end


end