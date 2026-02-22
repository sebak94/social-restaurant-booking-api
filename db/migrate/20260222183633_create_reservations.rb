class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :table, null: false, foreign_key: true
      t.datetime :reservation_time, null: false

      t.timestamps
    end

    add_index :reservations, %i[table_id reservation_time]
  end
end
