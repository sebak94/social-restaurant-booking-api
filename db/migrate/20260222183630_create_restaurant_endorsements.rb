class CreateRestaurantEndorsements < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurant_endorsements do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :dietary_restriction, null: false, foreign_key: true

      t.timestamps
    end

    add_index :restaurant_endorsements, %i[restaurant_id dietary_restriction_id], unique: true, name: :idx_restaurant_endorsements_uniqueness
  end
end
