class CreateRemovalcharges < ActiveRecord::Migration
  def change
    create_table :removalcharges do |t|
      t.text :charge
      t.references :removal, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
