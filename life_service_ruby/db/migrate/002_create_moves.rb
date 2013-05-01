#!/usr/bin/ruby
require 'active_record'

class CreateMoves < ActiveRecord::Migration
  def up
    create_table :moves do |t|
      t.column :name, :string
      t.column :url, :string
      t.column :desc, :string
      t.column :lab, :string
    end
  end

  def down
    drop_table :moves
  end

end
