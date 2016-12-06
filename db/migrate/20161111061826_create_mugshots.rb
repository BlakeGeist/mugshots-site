class CreateMugshots < ActiveRecord::Migration
  def change
    create_table :mugshots do |t|
      t.string :name
      t.string :county
      t.integer :county_id
      t.string :slug
      t.string :age
      t.string :booking_time

      t.timestamps null: false
    end
  end
end
