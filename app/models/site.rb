class Site < ApplicationRecord
  belongs_to :user
  validates :url, uniqueness: { scope: :user_id }
  validates :note, length: { maximum: 14000 }

  def get_site_info
    site_url = self.url
    page = MetaInspector.new(site_url)
    self.title = page.best_title if page.best_title
    self.description = page.best_description if page.best_description
    self.image_id = page.images.best
  end

end
