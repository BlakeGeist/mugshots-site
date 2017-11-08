class CreateRemovals < ActiveRecord::Migration
  def change
    create_table :removals do |t|
      t.string :name
      t.string :county
      t.string :email
      t.text :photo

      t.timestamps null: false
    end
  end
end
