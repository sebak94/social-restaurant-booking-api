class CreateDietaryRestrictions < ActiveRecord::Migration[8.1]
  def change
    create_table :dietary_restrictions do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :dietary_restrictions, :name, unique: true
  end
end
