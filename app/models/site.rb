class Site < ApplicationRecord
  belongs_to :user
  validates :url, uniqueness: { scope: :user_id }
  attachment :image
  
  def get_site_info
    require 'nokogiri'
    require 'open-uri'
    
    site_url = self.url
    
    html = URI.open(site_url).read
    
    doc = Nokogiri::HTML.parse(html)
    ogp_image = doc.css('//meta[property="og:image"]/@content').to_s
    ogp_title = doc.css('//meta[property="og:title"]/@content').to_s
    self.title = ogp_title
    self.image_id = ogp_image
  end
  
end
