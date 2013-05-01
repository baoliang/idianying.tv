require "active_record"

class EditMoves <ActiveRecord::Migration
  def up
    change_column("moves", "desc", "text")
  end

  def down
    change_column("moves", "desc", "string")
  end
end
