
require "active_record"

class AddColHot <ActiveRecord::Migration
  def up
    add_column "moves", "ups", "int"
    add_column "moves", "downs", "int"
    
  end

  def down
    remove_column "moves", "ups"
    remove_column "moves", "downs"
  end

end
