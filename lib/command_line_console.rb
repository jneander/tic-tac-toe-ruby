class CommandLineConsole
  attr_reader :characters

  def initialize
    @characters = Hash.new
    @characters[nil] = "_"
  end

  def set_players(players)
    @characters[players.first] = "O"
    @characters[players.last] = "X"
  end

  def convert_board_to_ascii(board)
    board.marks_by_row.collect {|row| row.collect {
      |mark| @characters[mark]}.join("|")}
  end
end
