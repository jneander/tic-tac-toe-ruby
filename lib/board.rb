class Board
  attr_reader :size, :spaces

  def initialize(size)
    @size = size
    @spaces= [:blank]*size.to_i**2
  end

  def make_mark(index, mark)
    @spaces[index] = mark
  end

  def spaces_with_mark(mark)
    @spaces.collect.with_index { |m, index| index if m == mark }.compact
  end
end
