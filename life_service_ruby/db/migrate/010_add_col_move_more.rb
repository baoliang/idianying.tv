require "active_record"

class AddColMoveMore <ActiveRecord::Migration
  def up
    add_column("moves", "created_at", "datetime")
    add_column("moves", "img_id", "string")
    add_column("moves", "version", "string")
  	add_column("moves", "source_img_url", "text")
  	add_column("moves", "p_list", "json")
  	add_column("moves", "language", "string")
  	add_column("moves", "area", "string")
  	add_column("moves", "upload_time", "string")

  end

  def down
    remove_column("moves", "created_at")
    remove_column("moves", "img_id")
    remove_column("moves", "version")
    remove_column("moves", "source_img_url")
    remove_column("moves", "p_list")
    remove_column("moves", "language")
    remove_column("moves", "area")
    remove_column("moves", "upload_time")

  end

end
