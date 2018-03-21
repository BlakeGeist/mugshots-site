class Mugshot < ActiveRecord::Base
  belongs_to :county
  has_many :photos, :dependent => :destroy
  has_many :charges, :dependent => :destroy
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def previous
    county.mugshots.where(["id > ?", id]).first
  end

  def next
    county.mugshots.where(["id < ?", id]).last
  end

  def self.search(search)
    if search
      self.where("name like ?", "%#{search}%")
    else
      self.all
    end
  end

 def slug_candidates
   [
     :name,
     [:name, :sequence]
   ]
 end

 def sequence
   slug = name.to_param
   return sequence = Mugshot.where("name like '#{slug}'").count + 2

 end

end
