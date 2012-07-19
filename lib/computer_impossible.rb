require 'mark'

class ImpossibleComputer
  attr_accessor :console
  attr_reader :opponent

  def initialize(opponent)
    @opponent = opponent
  end

  def get_best_space(board)
    board.spaces_with_mark(Mark::BLANK)[0]
  end

  def self.to_s
    "Impossible Computer"
  end
end
