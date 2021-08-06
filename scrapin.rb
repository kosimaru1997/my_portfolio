require 'nokogiri'
require 'open-uri'

url = 'https://qiita.com/karamaru/items/b30cf59ceea599bef48f'

html = URI.open(url).read

doc = Nokogiri::HTML.parse(html)
ogp_image = doc.css('//meta[property="og:image"]/@content')
ogp_title = doc.css('title').text
puts ogp_image
puts ogp_title