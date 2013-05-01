#!/usr/bin/ruby
require 'active_record'

class CreateLianxuju < ActiveRecord::Migration
  def up
    create_table :lianxujus do |t|
          t.column :name, :string
          t.column :num, :string
    end
    
  end

  def down
    drop_table :lianxujus
  end
end
