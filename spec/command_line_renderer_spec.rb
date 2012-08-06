require 'command_line_renderer'

describe CommandLineRenderer do
  before :all do
    @renderer = CommandLineRenderer.new
    @player_hash = {Board::BLANK => '_', :player => 'O', :opponent => 'X'}
  end

  before :each do
    @board = Board.new
  end

  it "#set_output receives a reference to an output stream" do
    @renderer.set_output($stdout)
  end

  context "with size 3 board" do
    before :each do
      @board = Board.new(3)
      make_marks(@board, [5,6], :player)
      make_marks(@board, [4,8], :opponent)
    end

    it "#board_to_ascii converts the board into ascii strings" do
      expected = ["_|_|_", "_|X|O", "O|_|X"]
      @renderer.board_to_ascii(@board, @player_hash).should == expected
    end

    it "#available_spaces_to_ascii converts available spaces to strings" do
      expected = ["1 2 3", "4    ", "  8  "]
      @renderer.available_spaces_to_ascii(@board).should == expected
    end
  end

  context "with size 4 board" do
    before :each do
      @board = Board.new(4)
      make_marks(@board, [4, 12, 13, 14, 15], :player)
      make_marks(@board, [6, 9, 10], :opponent)
    end

    it "#board_to_ascii converts a board of size 4 into ascii strings" do
      expected = ["_|_|_|_", "O|_|X|_", "_|X|X|_", "O|O|O|O"]
      @renderer.board_to_ascii(@board, @player_hash).should == expected
    end

    it "#available_spaces_to_ascii converts available spaces to strings" do
      expected = [" 1  2  3  4", "    6     8", " 9       12", "           "]
      @renderer.available_spaces_to_ascii(@board).should == expected
    end
  end

  it "creates a human-readable list of available opponents" do
    expected = "[1: Human, 2: Dumb Computer]"
    @renderer.players_as_options(["Human", "Dumb Computer"]).
      should == expected
  end

  private
  def make_marks(board, indices, symbol)
    indices.each {|index| board.make_mark(index, symbol)}
  end
end
