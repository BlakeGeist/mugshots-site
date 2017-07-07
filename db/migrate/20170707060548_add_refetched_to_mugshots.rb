class AddRefetchedToMugshots < ActiveRecord::Migration
  def change
    add_column :mugshots, :refetched, :boolean
  end
end
