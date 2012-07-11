require 'player_factory'
require 'board_factory'

class Game
  attr_accessor :board, :players

  def initialize(console)
    @board = BoardFactory.create
    @console = console
    @players = [nil,nil].collect {PlayerFactory.create}
    @players.each {|player| player.console = @console}
    @console.set_players(@players)
  end

  def run
    while not over?
      @console.display_board(@board)
      @players.first.make_mark(@board)
      @players.rotate!
    end
    @console.display_game_results(@board)
  end

  def over?
    @board.winning_solution?(*@players) || @board.spaces_with_mark(Mark::BLANK).empty?
  end
end
