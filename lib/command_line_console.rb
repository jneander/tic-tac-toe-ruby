require 'board'
require 'command_line_renderer'
require 'command_line_prompter'

class CommandLineConsole
  attr_reader :characters, :renderer, :prompter, :out
  attr_accessor :out

  def initialize(input, output)
    @prompter = CommandLinePrompter.new
    @prompter.set_input_output(input, output)
    @renderer = CommandLineRenderer.new
    @renderer.set_output(output)
    @characters = Hash.new
    @characters[Board::BLANK] = "_"
    @out = output
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

  def prompt_opponent_type(opponents)
    opponent_options = @renderer.players_as_options(opponents)
    message = "Choose your opponent #{opponent_options} : "
    @prompter.valid_input = (1..opponents.length).map {|v| v.to_s}
    value = @prompter.request("\n", message).to_i
    opponents[value - 1]
  end

  def prompt_player_order
    player_x = @characters.key('X')
    player_o = @characters.key('O')
    [player_x, player_o]
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

  def display_game_winner(player_number)
    @out.puts("", "Player #{player_number} is the winner!")
  end

  def display_game_draw
    @out.puts("", "The game has ended with a draw!")
  end
end
