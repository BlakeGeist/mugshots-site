class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.text :charge
      t.references :mugshot, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
