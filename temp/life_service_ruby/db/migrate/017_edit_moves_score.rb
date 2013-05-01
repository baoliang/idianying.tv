require "active_record"

class EditMovesScore <ActiveRecord::Migration
  def up
    change_column("moves", "score", "float")
  end

  def down
    change_column("moves", "score", "int")
  end
end
