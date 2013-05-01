
require "active_record"

class SetUpsDownZero <ActiveRecord::Migration
  def up
    execute "update moves set ups=0 where ups is null"
     execute "update moves set downs=0 where downs is null"
  end

  def down
   execute "update moves set ups=null where  ups=0"
      execute "update moves set downs=null where downs=0"
  end

end

