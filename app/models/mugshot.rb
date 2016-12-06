class Mugshot < ActiveRecord::Base
  belongs_to :county
  has_many :photos, :dependent => :destroy
  has_many :charges, :dependent => :destroy
  extend FriendlyId
  friendly_id :name, use: :history

  def previous
    county.mugshots.where(["id > ?", id]).first
  end

  def next
    county.mugshots.where(["id < ?", id]).last
  end
end
