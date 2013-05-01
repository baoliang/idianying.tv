require "active_record"

class EditMovesUpdate <ActiveRecord::Migration
  def up
    change_column("moves", "updated_at", "string")
  end

  def down
    change_column("moves", "desc", "datetime")
  end
end
