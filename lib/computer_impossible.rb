require 'minimax'

class ImpossibleComputer
  attr_accessor :console, :symbol
  attr_reader :minimax

  def initialize
    @minimax = Minimax.new
    @minimax.max_mark = self
  end

  def self.to_s
    "Impossible Computer"
  end

  def choose_move(board)
    @minimax.min_mark = get_opponent_symbol(board)
    space_scores = @minimax.scores(board, self)
    space_scores.sort_by {|space,score| score}.reverse.first[0]
  end

  def get_opponent_symbol(board)
    opponent_symbol = (board.symbols_added - [self]).first
    opponent_symbol.nil? ? :opponent : opponent_symbol
  end
end
