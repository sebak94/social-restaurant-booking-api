class CreateDinerRestrictions < ActiveRecord::Migration[8.1]
  def change
    create_table :diner_restrictions do |t|
      t.references :diner, null: false, foreign_key: true
      t.references :dietary_restriction, null: false, foreign_key: true

      t.timestamps
    end

    add_index :diner_restrictions, %i[diner_id dietary_restriction_id], unique: true
  end
end
