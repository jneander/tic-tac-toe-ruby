class Board
  attr_reader :size, :spaces

  def initialize(size)
    @size = size
    @spaces= [:blank]*size.to_i**2
  end

  def add_mark(index, mark)
    @spaces[index] = mark
  end
end
