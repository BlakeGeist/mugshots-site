class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.string :abbv
      t.text :list
      t.string :slug

      t.references :state, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
