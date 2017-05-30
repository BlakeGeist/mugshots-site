class AddDescriptionToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :description, :text
  end
end
