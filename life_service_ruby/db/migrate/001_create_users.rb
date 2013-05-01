#!/usr/bin/ruby
require 'active_record'

class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
          t.column :name, :string
          t.column :sex,  :string
          t.column :email, :string
          t.column :pwd, :string
          t.column :head_img, :string
    end
    
  end

  def down
    drop_table :users
  end
end
