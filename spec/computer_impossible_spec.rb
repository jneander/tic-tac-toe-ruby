require 'computer_impossible'

describe ImpossibleComputer do
  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "can receive and store a reference to the console" do
    @computer = ImpossibleComputer.new
    @computer.console = mock("Console")
  end
end
