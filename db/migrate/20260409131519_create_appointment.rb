class CreateAppointment < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.integer :pet_id
      t.integer :vet_id
      t.datetime :date
      t.string :reason
      t.integer :status

      t.timestamps
    end
  end
end
