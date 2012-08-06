BOARD_SIZE = 3

class Board
  attr_reader :size, :solutions, :symbols_added
  attr_accessor :spaces

  BLANK = :blank

  def initialize(board_size = BOARD_SIZE)
    @size = board_size
    reset
    generate_solutions
  end

  def reset
    @spaces = [BLANK]*@size.to_i**2
    @symbols_added = []
  end

  def make_mark(index, mark)
    @spaces[index] = mark
    update_symbols_added
  end

  def spaces_with_mark(mark)
    (0...@spaces.length).select {|index| @spaces[index].eql? mark}
  end

  def space_available?(index)
    index < @spaces.length and index >= 0 and @spaces[index].eql? BLANK
  end

  def winning_solution?(*marks)
    has_solution = false
    marks.each do |mark|
      marked_spaces = spaces_with_mark(mark)
      @solutions.each {|solution| has_solution |= (solution - marked_spaces).empty?}
    end
    has_solution
  end

  def update_symbols_added
    @symbols_added = @spaces.uniq - [BLANK]
  end

  def clone
    board = Board.new(@size)
    board.spaces = @spaces.clone
    board.update_symbols_added
    board
  end

  private
  def generate_solutions
    indices = (0...@size**2).to_a
    horizontal = indices.each_slice(@size).to_a
    vertical = horizontal.transpose
    diagonal_left = indices.select {|index| index % (@size + 1) == 0}
    diagonal_right = indices.select {|index|
      (index % (@size - 1) == 0) && (index > 0) && (index < indices.count - 1)
    }
    @solutions = horizontal + vertical + [diagonal_left] + [diagonal_right]
  end
end
