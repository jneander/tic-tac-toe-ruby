require 'computer_dumb'

TIMES = 1000
ALL_SPACES = (0..8).to_a
SOME_SPACES = (3..6).to_a

describe DumbComputer do
  before :all do
    @opponent = :player
    @computer = DumbComputer.new
  end

  context "when making marks" do
    before :each do
      @board = mock("board")
      @board.should_receive(:make_mark).exactly(TIMES).times
      @marks = []
    end

    it "makes a mark at random" do
      @board.stub!(:spaces_with_mark).and_return(ALL_SPACES)

      TIMES.times do
        @marks << @computer.make_mark(@board)
      end
      @marks.uniq.sort.should eql ALL_SPACES
    end

    it "marks only on unmarked spaces" do
      @board.stub!(:spaces_with_mark).and_return(SOME_SPACES)

      TIMES.times do
        @marks << @computer.make_mark(@board)
      end
      @marks.uniq.sort.should eql SOME_SPACES
    end
  end

  it "converts the class to a string" do
    DumbComputer.to_s.should == "Dumb Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("console")
  end
end
