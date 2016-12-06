class State < ActiveRecord::Base
  has_many :counties, :dependent => :destroy
  extend FriendlyId
  friendly_id :name, use: :history
end
