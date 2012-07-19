require 'computer_impossible'

describe ImpossibleComputer do
  before :all do
    @computer = ImpossibleComputer.new
  end

  before :each do
    @board = mock("Board")
  end

  it "converts the class to a string" do
    ImpossibleComputer.to_s.should == "Impossible Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("Console")
  end

  it "returns the last available space to mark" do
    @board.stub!(:spaces_with_mark).and_return([8])
    @computer.get_best_space(@board).should == 8
  end
end
