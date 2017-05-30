class State < ActiveRecord::Base
  has_many :counties, :dependent => :destroy
  accepts_nested_attributes_for :counties
  extend FriendlyId
  friendly_id :name, use: :history
end
