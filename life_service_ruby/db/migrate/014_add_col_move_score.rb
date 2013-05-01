require "active_record"

class AddColMoveScore <ActiveRecord::Migration
  def up
    add_column("moves", "score", "int")
    add_column("moves", "json", "json")
	add_column("moves", "weight", "int")
	execute "CREATE EXTENSION hstore"
	create_table :kvs do |t|
	  t.column :key, :string
	  t.column :data, :hstore
	  t.column :created_at, :datetime
	end
	create_table :historys do |t|
	  t.column :move_id, :int
	  t.column :email, :string
	  t.column :created_at, :datetime
	end
	create_table :favs do |t|
	  t.column :move_id, :int
	  t.column :email, :string
	  t.column :created_at, :datetime
	end
	
  end

  def down
    remove_column("moves", "score")
 	remove_column("moves", "json")
 	remove_column("weight", "int")
 	drop_table :kvs
 	drop_table :favs
 	drop_table :historys
  end

end
