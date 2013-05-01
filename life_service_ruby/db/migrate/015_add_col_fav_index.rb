require "active_record"

class AddColFavIndex <ActiveRecord::Migration
  def up
  	rename_table "historys", "histories"
    add_column("histories", "index", "int")
  end

  def down
    remove_column("histories", "index")
    rename_table "histories", "historys"
 
  end

end
