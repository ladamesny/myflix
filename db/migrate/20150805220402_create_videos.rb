class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string  :title
      t.text  :description
      t.text :small_img
      t.text :large_img
      t.integer :category_id
      t.timestamps
    end
  end
end
