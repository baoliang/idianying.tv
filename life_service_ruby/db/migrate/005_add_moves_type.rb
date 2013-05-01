require "active_record"

class AddMovesType <ActiveRecord::Migration
  def up
    add_column("moves", "type", "string")
  end

  def down
    remove_column("moves", "type", "string")
  end

end
