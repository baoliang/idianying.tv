require "active_record"

class AddColMoveUpdateTime <ActiveRecord::Migration
  def up
    add_column("moves", "update_time", "datetime")

    remove_column("moves", "types")
    remove_column("moves", "url")
    remove_column("moves", "pic")
    remove_column("moves", "lab")
  end

  def down
    remove_column("moves", "update_time")
    
  end

end
