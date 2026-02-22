class CreateTables < ActiveRecord::Migration[8.1]
  def change
    create_table :tables do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.integer :capacity, null: false

      t.timestamps
    end
  end
end
