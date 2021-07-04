# frozen_string_literal: true

class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true, inverse_of: :active_notifications
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true, inverse_of: :passive_notifications
end
