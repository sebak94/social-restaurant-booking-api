class CreateReservationDiners < ActiveRecord::Migration[8.1]
  def change
    create_table :reservation_diners do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :diner, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reservation_diners, %i[reservation_id diner_id], unique: true
  end
end
