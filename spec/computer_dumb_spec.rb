require 'computer_dumb'

describe DumbComputer do
  before :each do
    @computer = DumbComputer.new
  end

  it "makes a mark at random" do
    TIMES = 1000
    ALL_SPACES = (0..8).sort
    @board = mock("board")
    @board.should_receive(:spaces_with_mark).exactly(TIMES).times
      .and_return(ALL_SPACES)
    @board.should_receive(:make_mark).exactly(TIMES).times
    marks = []

    TIMES.times do
      marks << @computer.make_mark(@board)
    end
    marks.uniq.sort.should eql ALL_SPACES
  end
end
