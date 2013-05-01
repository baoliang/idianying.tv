require "active_record"

class AddColLianxuju <ActiveRecord::Migration
  def up
    add_column("lianxujus", "url", "string")
  end

  def down
    remove_column("lianxujus", "url", "string")

  end

end
