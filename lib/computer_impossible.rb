class ImpossibleComputer
  attr_reader :opponent

  def initialize(opponent)
    @opponent = opponent
  end

  def self.to_s
    "Impossible Computer"
  end
end
