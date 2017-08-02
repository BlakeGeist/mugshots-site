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

  friendly_id :slug_candidates, use: :slugged


 def slug_candidates
   [:name, :name_and_sequence]
 end

 def name_and_sequence
   slug = name.to_param
   sequence = Mugshot.where(name: "#{slug}-").count + 2
   "#{slug}--#{sequence}"
 end

end
