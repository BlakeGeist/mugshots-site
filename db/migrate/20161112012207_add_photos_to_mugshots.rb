class AddPhotosToMugshots < ActiveRecord::Migration
  def change
    add_column :mugshots, :photo, :string
  end
end
