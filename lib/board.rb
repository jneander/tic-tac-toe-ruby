BOARD_SIZE = 3

class Board
  attr_reader :size, :spaces, :solutions

  def initialize(board_size = BOARD_SIZE)
    @size = board_size
    @spaces= [:blank]*@size.to_i**2
    generate_solutions
  end

  def make_mark(index, mark)
    @spaces[index] = mark
  end

  def spaces_with_mark(mark)
    (0...@spaces.length).select {|index| @spaces[index] == mark}
  end

  def marks_by_row
    @spaces.each_slice(@size).to_a
  end

  def winning_solution?(*marks)
    has_solution = false
    marks.each do |mark|
      marked_spaces = spaces_with_mark(mark)
      @solutions.each {|solution| has_solution |= (solution - marked_spaces).empty?}
    end
    has_solution
  end

  private
  def generate_solutions
    @solutions = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[6,4,2]
    ]
  end
end
