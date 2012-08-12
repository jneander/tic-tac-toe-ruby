class MinimaxCache
  attr_accessor :map

  def initialize
    @map = {}
  end

  def add_score(spaces, score)
    @map[spaces] = score
  end

  def get_score(spaces)
    @map[spaces]
  end

  def scored?(spaces)
    @map[spaces].is_a?(Integer)
  end

  def incomplete?(spaces)
    @map[spaces] == :incomplete
  end
end
