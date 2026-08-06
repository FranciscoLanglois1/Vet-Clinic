class AddPhotoToPets < ActiveRecord::Migration[8.1]
  def change
    add_column :pets, :photo, :string
  end
end
