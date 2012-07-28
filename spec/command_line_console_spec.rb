require 'command_line_console'
require 'command_line_prompter'

describe "CommandLineConsole" do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @prompter = CommandLinePrompter.new
    @prompter.set_input_output(@input, @output)
  end

  before :each do
    @console = CommandLineConsole.new(@prompter)
    @players = [:player1, :player2]
    @console.set_players(@players)
    @spaces_blank = [Board::BLANK]*9
    @spaces_with_marks = [Board::BLANK, @players.first, @players.last]*3
    @console.out = @output
  end

  it "assigns ASCII characters to players and marks in 'Game'" do
    @console.characters[:player1].should == 'O'
    @console.characters[:player2].should == 'X'
    @console.characters[Board::BLANK].should == '_'
  end

  it "receives command-line input when prompted" do
    @input.reopen('2', 'r+')
    @console.prompt_player_mark.should eql 1
  end

  it "prompts the user to play again" do
    @output.should_receive(:print).exactly(3).times
    @input.should_receive(:gets).and_return('a', '1', 'y')
    @console.prompt_play_again.should == true
  end

  it "prompts the user to choose a mark" do
    @output.should_receive(:print).exactly(3).times
    @input.should_receive(:gets).and_return('a', 'x', 'X')
    @console.prompt_mark_symbol.should == 'X'
  end

  context "when prompting the user to specify an opponent" do
    before :each do
      @opponent_options = [:human,:computer]
    end

    it "accepts an input within a valid range" do
      @input.reopen('1', 'r')
      @console.prompt_opponent_type(@opponent_options).should == :human
    end

    it "continues prompting until receiving a valid input" do
      @output.should_receive(:print).exactly(3).times
      @input.should_receive(:gets).and_return('0', '3', '1')
      @console.prompt_opponent_type(@opponent_options).should == :human
    end
  end

  it "assigns 'X' and 'O' to player and opponent" do
    given_hash = {:player1 => nil, :player2 => nil}
    target_hash = {:player1 => 'X', :player2 => 'O'}
    @input.stub!(:gets).and_return('X')
    @console.prompt_for_marks(given_hash).should == target_hash
  end

  it "creates a human-readable list of available opponents" do
    expected = "[1: Human, 2: Dumb Computer]"
    @console.players_as_options(["Human", "Dumb Computer"])
      .should == expected
  end

  it "creates an array of strings representing the board" do
    @board = mock("board")
    @board.should_receive(:size).any_number_of_times.and_return(3)
    [
      [@spaces_blank, ["_|_|_"]*3],
      [@spaces_with_marks, ["_|O|X"]*3],
    ].each do |spaces, expected|
      @board.should_receive(:spaces).and_return(spaces)
      @console.convert_board_to_ascii(@board).should == expected
    end
  end

  it "creates an array of strings representing available board spaces" do
    @board = mock("board")
    @board.should_receive(:size).any_number_of_times.and_return(3)
    [
      [@spaces_blank, ["1 2 3", "4 5 6", "7 8 9"]],
      [@spaces_with_marks, ["1    ", "4    ", "7    "]],
    ].each do |spaces, expected|
      @board.should_receive(:spaces).and_return(spaces)
      @console.available_spaces_to_ascii(@board).should == expected
    end
  end
end
