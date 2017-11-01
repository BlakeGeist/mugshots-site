class AddOrgUrlToMugshots < ActiveRecord::Migration
  def change
    add_column :mugshots, :org_url, :text
  end
end
