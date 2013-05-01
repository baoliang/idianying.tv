require "active_record"

class AddColMoveType <ActiveRecord::Migration
  def up
    add_column("moves", "types", "string")
    remove_column("moves", "type")
  end

  def down
    remove_column("moves", "types")
    add_column("moves", "type", "string")
  end

end
