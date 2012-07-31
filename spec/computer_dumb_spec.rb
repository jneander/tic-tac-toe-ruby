require 'computer_dumb'

TIMES = 1000
ALL_SPACES = (0..8).to_a
SOME_SPACES = (3..6).to_a

describe DumbComputer do
  before :all do
    @computer = DumbComputer.new
  end

  before :each do
    @board = mock("Board").as_null_object
  end

  it "#choose_move chooses a move at random" do
    @board.stub!(:spaces_with_mark).and_return(ALL_SPACES)
    marks = []

    TIMES.times do marks << @computer.choose_move(@board) end
    marks.uniq.sort.should eql ALL_SPACES
  end

  it "#choose_move chooses only unmarked spaces" do
    @board.stub!(:spaces_with_mark).and_return(SOME_SPACES)
    marks = []

    TIMES.times do marks << @computer.choose_move(@board) end
    marks.uniq.sort.should eql SOME_SPACES
  end

  it "converts the class to a string" do
    DumbComputer.to_s.should == "Dumb Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("console")
  end
end
