require 'player_factory'
require 'board_factory'

class Game
  attr_accessor :board, :players, :player_factory

  def initialize(console)
    @player_factory = PlayerFactory
    @board = BoardFactory.create
    @console = console
    @players = [@player_factory.create(@player_factory.HUMAN),
      @player_factory.create(@player_factory.HUMAN)]
    @players.each {|player| player.console = @console}
    @console.set_players(@players)
  end

  def run
    @console.prompt_opponent_type(@player_factory.TYPES)
    while not over?
      @console.display_board(@board)
      @players.first.make_mark(@board)
      @players.rotate!
    end
    @console.display_game_results(@board)
  end

  def over?
    @board.winning_solution?(*@players) ||
      @board.spaces_with_mark(Mark::BLANK).empty?
  end
end
