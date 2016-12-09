class AddQueToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :que_list, :text
  end
end
