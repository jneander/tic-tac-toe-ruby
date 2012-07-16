require 'command_line_console'
require 'mark'

describe "CommandLineConsole" do
  before :each do
    @console = CommandLineConsole.new
    @players = [:player1,:player2]
    @console.set_players(@players)
    @spaces_blank = [Mark::BLANK]*9
    @spaces_with_marks = [Mark::BLANK,@players.first,@players.last]*3
    $stdout = StringIO.new('','w')
  end

  it "assigns ASCII characters to players and marks in 'Game'" do
    @console.characters[:player1].should eql 'O'
    @console.characters[:player2].should eql 'X'
    @console.characters[Mark::BLANK].should eql '_'
  end

  it "receives command-line input when prompted" do
    $stdin = StringIO.new('2','r')
    @console.prompt_player_mark.should eql 1
  end

  it "prompts the user to specify the opponent type" do
    $stdin = StringIO.new('1','r')
    @console.prompt_opponent_type.should eql 1
  end

  it "creates a human-readable list of available opponents" do
    expected = "[1: Human, 2: Dumb Computer]"
    @console.players_as_options(["Human","Dumb Computer"]).should eql expected
  end

  it "creates an array of strings representing the board" do
    @board = mock("board")
    @board.should_receive(:size).any_number_of_times.and_return(3)
    [
      [@spaces_blank, ["_|_|_"]*3],
      [@spaces_with_marks, ["_|O|X"]*3],
    ].each do |spaces, expected|
      @board.should_receive(:spaces).and_return(spaces)
      @console.convert_board_to_ascii(@board).should eql expected
    end
  end

  it "creates an array of strings representing available board spaces" do
    @board = mock("board")
    @board.should_receive(:size).any_number_of_times.and_return(3)
    [
      [@spaces_blank, ["1 2 3","4 5 6","7 8 9"]],
      [@spaces_with_marks, ["1    ","4    ","7    "]],
    ].each do |spaces, expected|
      @board.should_receive(:spaces).and_return(spaces)
      @console.available_spaces_to_ascii(@board).should eql expected
    end
  end
end
