require "active_record"

class AddColMoveUpdatedAt <ActiveRecord::Migration
  def up
    add_column("moves", "updated_at", "datetime")
  
  end

  def down
    remove_column("moves", "updated_at")

  end

end
