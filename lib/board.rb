class Board
  attr_reader :size, :spaces

  def initialize(size)
    @size = size
    @spaces= [:blank]*size.to_i**2
  end
end
