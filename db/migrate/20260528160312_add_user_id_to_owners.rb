class AddUserIdToOwners < ActiveRecord::Migration[8.1]
  def change
    add_reference :owners, :user, null: false, foreign_key: true
  end
end
