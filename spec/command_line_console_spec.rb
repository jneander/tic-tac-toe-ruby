require 'command_line_console'

describe "CommandLineConsole" do
  before :each do
    @console = CommandLineConsole.new
  end

  it "assigns ASCII characters to players in 'Game'" do
    @players = [:player1,:player2]
    @console.set_players(@players)
    @console.characters[:player1].should eql 'O'
    @console.characters[:player2].should eql 'X'
  end

  it "places the representation of a board into arrays" do
    @board = mock("board")
    @board.should_receive(:marks_by_row).and_return([[nil]*3]*3)
    @console.convert_board_to_ascii(@board).should eql ["_|_|_"]*3
  end
end
