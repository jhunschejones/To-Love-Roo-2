class ChangeNoteTextToText < ActiveRecord::Migration[6.0]
  def up
    change_column :notes, :text, :text
  end

  def down
    change_column :notes, :text, :string
  end
end
