class AddUserIdToVets < ActiveRecord::Migration[8.1]
  def change
    add_reference :vets, :user, null: false, foreign_key: true
  end
end
