class Removal < ActiveRecord::Base
  after_create :add_charges
  has_many :removalcharges

  accepts_nested_attributes_for :removalcharges

  def add_charges

    removal = Removal.last

    mugshot = Mugshot.find(self.mugshotID)

    mugshot.charges.each do |charge|

      removal.removalcharges.create(charge: charge.charge)

    end

    mugshot.destroy

  end

end
