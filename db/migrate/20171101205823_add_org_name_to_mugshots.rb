class AddOrgNameToMugshots < ActiveRecord::Migration
  def change
    add_column :mugshots, :org_name, :string
  end
end
