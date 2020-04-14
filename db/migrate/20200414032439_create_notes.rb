class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :text, null: false
      t.string :creator_id, null: false
      t.string :recipient_id, null: false

      t.timestamps
    end
  end
end
