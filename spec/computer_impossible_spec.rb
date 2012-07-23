require 'computer_impossible'

describe ImpossibleComputer do
  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "is initialized with an opponent" do
    @opponent = :player
    @computer = ImpossibleComputer.new(@opponent)
  end
end
