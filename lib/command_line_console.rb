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
    board.spaces.each_slice(board.size).collect {|row| row.collect {
      |mark| @characters[mark]}.join("|")}
  end

  def available_spaces_to_ascii(board)
    board.spaces.collect.with_index {|space, index| space == nil ? index + 1 : " "}
      .each_slice(board.size).to_a.collect {|row| row.join(" ")}
  end
end
