
require "active_record"

class SetMovesScoreZero <ActiveRecord::Migration
  def up
    execute "update moves set score=0 where score is null"
  end

  def down
    execute "update moves set score=null where score =0"
  end

end

