require 'mark'
require 'minimax'

class ImpossibleComputer
  attr_accessor :console
  attr_reader :opponent

  def initialize(opponent)
    @opponent = opponent
    @solver = Minimax.new
  end

  def get_best_space(board)
    available_spaces = board.spaces_with_mark(Mark::BLANK)
    best_space, best_score = available_spaces[0], -1

    available_spaces.each do |space|
      board.make_mark(space,self)
      score = @solver.score(board,@opponent)
      board.make_mark(space,Mark::BLANK)
      best_space, best_mark = space, score if score > best_score
    end

    best_space
  end

  def self.to_s
    "Impossible Computer"
  end
end
