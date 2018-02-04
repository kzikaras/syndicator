class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.integer :price
      t.text :description
      t.string :venue

      t.timestamps
    end
  end
end
