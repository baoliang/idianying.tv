require "mongo"


class Gridfs
  def initialize
    @conn = Mongo::Connection.new
    @db   = @conn['move']
    @grid = Mongo::Grid.new(@db)
  end
  def save_file name, file
    @grid.put(file, {:filename=> name})
  end

  def get(id)
    @grid.get(id)
  end
end

