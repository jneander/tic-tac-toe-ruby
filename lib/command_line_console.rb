class CommandLineConsole
  attr_reader :characters
  attr_accessor :out

  def initialize(prompter, renderer)
    @prompter = prompter
    @renderer = renderer
    @characters = Hash.new
    @characters[Board::BLANK] = "_"
    @out = $stdout
  end

  def set_players(players)
    @players = players.clone
    @characters[players.first] = "O"
    @characters[players.last] = "X"
  end

  def assign_marks(players_hash)
    symbols = players_hash.keys
    @characters[symbols.first] = prompt_mark_symbol
    other_mark = (['X', 'O'] - [@characters[symbols.first]]).first
    @characters[symbols.last] = other_mark
  end

  def display_board(board)
    output = @renderer.board_to_ascii(board, @characters).
      collect {|row| "%10s" % row}
    @out.puts("", *output)
  end

  def display_board_choices(board)
    print_board = @renderer.board_to_ascii(board, @characters)
    print_available = @renderer.available_spaces_to_ascii(board)
    output = (0...print_board.size).collect {|index| 
      "%10s%10s" % [print_board[index], print_available[index]]
    } 
    @out.puts("", *output)
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
    opponent_options = @renderer.players_as_options(opponents)
    message = "Choose your opponent #{opponent_options} : "
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
    output = @renderer.board_to_ascii(board, @characters).
      collect {|row| "%10s" % row}
    message = if board.winning_solution?(*@players)
      player_number = board.winning_solution?(@players.first) ? 1 : 2
      "Player #{player_number} is the winner!"
    else
      "The game has ended with a draw!"
    end
    @out.puts("",*output,"",message)
  end

  def display_game_winner(player_number)
    @out.puts("", "Player #{player_number} is the winner!")
  end

  def display_game_draw
    @out.puts("", "The game has ended with a draw!")
  end
end
