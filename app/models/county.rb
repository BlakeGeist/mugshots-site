class County < ActiveRecord::Base
  belongs_to :state
  has_many :mugshots

  extend FriendlyId
  friendly_id :name, use: :slugged

end
