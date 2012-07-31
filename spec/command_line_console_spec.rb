require 'command_line_console'
require 'command_line_prompter'
require 'command_line_renderer'

describe "CommandLineConsole" do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @prompter = CommandLinePrompter.new
    @prompter.set_input_output(@input, @output)
    @renderer = CommandLineRenderer.new
    @renderer.set_output(@output)
    @players = [:player1, :player2]
  end

  before :each do
    @console = CommandLineConsole.new(@prompter, @renderer)
    @console.set_players(@players)
    @console.out = @output
  end

  it "#assign_marks issues a prompt through a prompter" do
    hash = {:player1 => :PLAYER_ONE, :player2 => :PLAYER_TWO}
    @console.should_receive(:prompt_mark_symbol).and_return('O')
    @console.assign_marks(hash)
  end

  it "#assign_marks assigns ASCII characters to players" do
    hash = {:player1 => :PLAYER_ONE, :player2 => :PLAYER_TWO}
    @console.stub!(:prompt_mark_symbol).and_return('O')
    @console.assign_marks(hash)
    @console.characters[:player1].should eql 'O'
    @console.characters[:player2].should eql 'X'
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

  it "#display_game_winner prints a message to the terminal" do
    @console.out.should_receive(:puts)
    @console.display_game_winner(1)
  end

  it "#display_game_draw prints a message to the terminal" do
    @console.out.should_receive(:puts)
    @console.display_game_draw
  end

  context "#display_board_choices" do
    before :each do
      @board = mock("Board").as_null_object
      board_ascii = ["_|_|_", "X|O|_", "_|X|O"]
      choices_ascii = ["1 2 3", "    6", "7    "]
      @renderer.stub!(:board_to_ascii).and_return(board_ascii)
      @renderer.stub!(:available_spaces_to_ascii).and_return(choices_ascii)
    end

    it "converts available spaces" do
      @renderer.should_receive(:available_spaces_to_ascii)
      @console.display_board_choices(@board)
    end

    it "converts board to ascii" do
      @renderer.should_receive(:board_to_ascii)
      @console.display_board_choices(@board)
    end

    it "displays the board with choices" do
      formatted = [ "     _|_|_     1 2 3", 
                    "     X|O|_         6",
                    "     _|X|O     7    "] 
      @output.should_receive(:puts).with("", *formatted)
      @console.display_board_choices(@board)
    end
  end
end
