require 'command_line_game_renderer'

describe CommandLineGameRenderer do
  before :all do
    @renderer = CommandLineGameRenderer.new
  end

  before :each do
    @board = Board.new
  end

  it "#set_output receives a reference to an output stream" do
    @renderer.set_output($stdout)
  end

  it "#board_to_ascii converts a board into ascii strings" do
    make_marks([5,6], :player)
    make_marks([4,8], :opponent)
    hash = {Board::BLANK => '_', :player => 'O', :opponent => 'X'}
    expected = ["_|_|_", "_|X|O", "O|_|X"]
    @renderer.board_to_ascii(@board, hash).should == expected
  end

  it "#available_spaces_to_ascii converts available spaces to strings" do
    make_marks([5,6], :player)
    make_marks([4,8], :opponent)
    expected = ["1 2 3", "4    ", "  8  "]
    @renderer.available_spaces_to_ascii(@board).should == expected
  end

  it "creates a human-readable list of available opponents" do
    expected = "[1: Human, 2: Dumb Computer]"
    @renderer.players_as_options(["Human", "Dumb Computer"]).
      should == expected
  end

  private
  def make_marks(indices, symbol)
    indices.each {|index| @board.make_mark(index, symbol)}
  end
end
