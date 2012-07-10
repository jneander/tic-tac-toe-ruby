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

  it "creates an array of strings representing the board" do
    @board = mock("board")
    @board.should_receive(:marks_by_row).and_return([[nil]*3]*3)
    @console.convert_board_to_ascii(@board).should eql ["_|_|_"]*3
  end

  it "creates an array of strings representing available board spaces" do
    @board = mock("board")
    @board.should_receive(:spaces).and_return([nil]*9)
    @board.should_receive(:size).and_return(3)
    @console.available_spaces_to_ascii(@board).should eql ["1 2 3","4 5 6","7 8 9"]
  end
end
