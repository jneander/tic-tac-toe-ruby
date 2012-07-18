require 'computer_dumb'

TIMES = 1000
ALL_SPACES = (0..8).sort
SOME_SPACES = (3..6).sort

describe DumbComputer do
  before :all do
    @computer = DumbComputer.new
  end

  context "when making marks" do
    before :each do
      @board = mock("board")
      @board.should_receive(:make_mark).exactly(TIMES).times
      @marks = []
    end

    it "makes a mark at random" do
      @board.should_receive(:spaces_with_mark).exactly(TIMES).times
        .and_return(ALL_SPACES)

      TIMES.times do
        @marks << @computer.make_mark(@board)
      end
      @marks.uniq.sort.should eql ALL_SPACES
    end

    it "marks only on unmarked spaces" do
      @board.should_receive(:spaces_with_mark).exactly(TIMES).times
        .and_return(SOME_SPACES)

      TIMES.times do
        @marks << @computer.make_mark(@board)
      end
      @marks.uniq.sort.should eql SOME_SPACES
    end
  end

  it "converts the class to a string" do
    DumbComputer.to_s.should eql "Dumb Computer"
  end

  it "can receive and store a reference to the console" do
    @computer.console = mock("console")
  end
end
