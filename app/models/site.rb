class Site < ApplicationRecord
  belongs_to :user
  validates :url, uniqueness: { scope: :user_id }
  validates :note, length: { maximum: 100 }

  def get_site_info
    require 'nokogiri'
    require 'open-uri'

    site_url = self.url

    html = URI.open(site_url).read

    doc = Nokogiri::HTML.parse(html)
    ogp_image = doc.css('//meta[property="og:image"]/@content')
    ogp_title = doc.css('title').text
    self.title = ogp_title
    self.image_id = ogp_image
  end

end
