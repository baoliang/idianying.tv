require "active_record"

class AddColMove <ActiveRecord::Migration
  def up
    add_column("moves", "director", "string")
    add_column("moves", "actor", "text")
    add_column("moves", "status", "string")
    add_column("moves", "label", "string")
    add_column("moves", "pic", "string")
  end

  def down
    remove_column("moves", "director", "string")
    remove_column("moves", "actor", "text")
    remove_column("moves", "status", "string")
    remove_column("moves", "label", "string")
    remove_column("moves", "pic", "string")
  end

end
