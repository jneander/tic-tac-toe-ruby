require 'computer_impossible'

describe ImpossibleComputer do
  it "is initialized with an opponent" do
    @opponent = :player
    @computer = ImpossibleComputer.new(@opponent)
  end
end
