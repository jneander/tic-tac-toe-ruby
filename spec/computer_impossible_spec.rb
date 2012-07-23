require 'computer_impossible'

describe ImpossibleComputer do
  before :all do
    @opponent = :player
    @computer = ImpossibleComputer.new(@opponent)
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "is initialized with an opponent" do
    @computer.opponent.should == @opponent
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end
end
