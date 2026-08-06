class CreateVet < ActiveRecord::Migration[8.1]
  def change
    create_table :vets do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :specialization

      t.timestamps
    end
  end
end
