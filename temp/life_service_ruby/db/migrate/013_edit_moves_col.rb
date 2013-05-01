require "active_record"

class EditMovesCol <ActiveRecord::Migration
  def up
  	
    rename_column("moves", "desc", "describe")
  end

  def down
    rename_column("moves", "describe", "desc")
  end
end
