class CreateTreatment < ActiveRecord::Migration[8.1]
  def change
    create_table :treatments do |t|
      t.integer :appointment
      t.string :name
      t.string :medication
      t.string :dosage
      t.text :notes
      t.datetime :administered_at

      t.timestamps
    end
  end
end
