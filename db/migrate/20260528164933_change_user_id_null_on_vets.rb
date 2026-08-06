class ChangeUserIdNullOnVets < ActiveRecord::Migration[8.1]
  def change
    change_column_null :vets, :user_id, true
    change_column_null :owners, :user_id, true
  end
end
