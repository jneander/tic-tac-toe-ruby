class CommandLineConsole
  attr_reader :characters

  def initialize
    @characters = Hash.new
    @characters[nil] = "_"
  end

  def set_players(players)
    @players = players.clone
    @characters[players.first] = "O"
    @characters[players.last] = "X"
  end

  def display_board(board)
    print_board = convert_board_to_ascii(board)
    print_available = available_spaces_to_ascii(board)
    (0...board.size).each {|index| 
      printf("%10s%10s\n", print_board[index], print_available[index])
    }
  end

  def display_game_results(board)
    convert_board_to_ascii(board).each {|row| printf("%10s\n", row)}
    if board.winning_solution?(*@players)
      winner = board.winning_solution?(@players.first) ? 1 : 2
      message = "Player #{winner} is the winner!"
    else
      message = "The game has ended in a tie!"
    end
    puts message
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
