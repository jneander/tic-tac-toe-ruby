class Game
  attr_accessor :board

  def over?
    @board.winning_solution?(:player1,:player2) || @board.spaces_with_mark(:blank).empty?
  end
end
