class ImpossibleComputer
  attr_accessor :console
  attr_reader :opponent

  def initialize(opponent)
    @opponent = opponent
    @minimax = Minimax.new
  end

  def self.to_s
    "Impossible Computer"
  end

  def get_best_space(board)
    space_scores = @minimax.scores(board, self)
    space_scores.sort_by {|space,score| score}.reverse.first[0]
  end

  def make_mark(board)
    board.make_mark(get_best_space(board), self)
  end
end
