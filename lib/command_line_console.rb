class CommandLineConsole
  attr_reader :characters
  attr_accessor :out

  def initialize(prompter)
    @prompter = prompter
    @characters = Hash.new
    @characters[Board::BLANK] = "_"
    @out = $stdout
  end

  def set_players(players)
    @players = players.clone
    @characters[players.first] = "O"
    @characters[players.last] = "X"
  end

  def display_board(board)
    print_board = convert_board_to_ascii(board)
    print_available = available_spaces_to_ascii(board)
    output = (0...board.size).collect {|index| 
      "%10s%10s" % [print_board[index],print_available[index]]
    }
    @out.puts("",*output)
  end

  def prompt_mark_symbol
    message = "Please choose the mark you would like to use ('X' or 'O'): "
    @prompter.valid_input = ['X', 'O']
    @prompter.request("\n", message)
  end

  def prompt_player_mark
    message = "Please choose the number of the space for your mark: "
    @prompter.valid_input = ('1'..'9').to_a
    result = @prompter.request("\n", message)
    result.to_i - 1
  end

  def prompt_for_marks(hash)
    result, symbol = {}, ""
    message = "Please choose a mark for #{hash.values.first} ('X' or 'O'): "
    @prompter.valid_input = ['X', 'O']
    symbol = @prompter.request("\n", message)

    result[hash.keys.first] = symbol
    result[hash.keys.last] = (['X','O'] - [symbol]).first
    result
  end

  def prompt_opponent_type(opponents)
    message = "Choose your opponent #{players_as_options(opponents)} : "
    @prompter.valid_input = (1..opponents.length).map {|v| v.to_s}
    value = @prompter.request("\n", message).to_i
    opponents[value - 1]
  end

  def prompt_play_again
    message = "Would you like to play again? (y/n) : "
    @prompter.valid_input = ['y', 'n']
    play_again = @prompter.request("\n", message)
    play_again == "y" ? true : false
  end

  def alert_space_unavailable(index)
    @out.puts("","The space you've selected is unavailable")
  end

  def display_game_results(board)
    output = convert_board_to_ascii(board).collect {|row| "%10s" % row}
    message = if board.winning_solution?(*@players)
      player_number = board.winning_solution?(@players.first) ? 1 : 2
      "Player #{player_number} is the winner!"
    else
      "The game has ended with a draw!"
    end
    @out.puts("",*output,"",message)
  end

  def convert_board_to_ascii(board)
    board.spaces.each_slice(board.size).collect {|row|
      row.collect {|mark| @characters[mark]}.join("|")}
  end

  def available_spaces_to_ascii(board)
    board.spaces.collect.with_index {|space, index|
      space.eql?(Board::BLANK) ? index + 1 : " "
    }.each_slice(board.size).to_a.collect {|row| row.join(" ")}
  end

  def players_as_options(players)
    "[%s]" % players.collect.with_index {|player,index|
      "%d: %s" % [index+1, player]}.join(", ")
  end
end
