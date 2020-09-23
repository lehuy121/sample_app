class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_created_at_desc, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: :invalid_image_format },
       size: { less_than: 5.megabytes,
               message: :should_be_less_than }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
