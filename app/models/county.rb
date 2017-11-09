class County < ActiveRecord::Base
  belongs_to :state
  has_many :mugshots, :dependent => :destroy

  extend FriendlyId
  friendly_id :name, use: :slugged

end
