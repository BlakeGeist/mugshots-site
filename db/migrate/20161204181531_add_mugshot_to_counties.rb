class AddMugshotToCounties < ActiveRecord::Migration
  def change
    add_reference :counties, :mugshot, index: true, foreign_key: true
  end
end
