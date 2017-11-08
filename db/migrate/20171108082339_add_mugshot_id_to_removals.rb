class AddMugshotIdToRemovals < ActiveRecord::Migration
  def change
    add_column :removals, :mugshotID, :integer
  end
end
