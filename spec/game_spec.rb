require 'game'
require 'command_line_console'
require 'configuration'

describe Game do
  before :all do
    input = StringIO.new('', 'r+')
    output = StringIO.new('', 'w')
    @console = CommandLineConsole.new(input, output)
    @config = Configuration.new(@console)
  end

  before :each do
    @player1 = mock("player").as_null_object
    @player2 = mock("player").as_null_object
    stub_configuration
    @game = Game.new(@config)
    @game.board.stub!(:make_mark)
  end

  context "at initialization" do
    it "#over? returns false" do
      @game.board.stub!(:winning_solution?).and_return(false)
      @game.board.stub!(:spaces_with_mark).and_return([nil]*9)
      @game.over?.should == false
    end

    it "#initialize will clone the player list from configuration" do
      @game.players.should eql @config.players
      @game.players.should_not equal @config.players
      @game.players.each_index do |index|
        @game.players[index].should equal @config.players[index]
      end
    end

    it "#initialize stores the board from the configuration" do
      @game.board.should equal @config.board
    end
  end

  context "while in 'until over?' loop" do
    before :each do
      @game.board.stub!(:make_mark)
      @game.stub!(:valid_move?).and_return(*([false, true]*10))
    end

    it "requests the console to display the board with choices" do
      set_run_loop_limit(1)
      @console.should_receive(:display_board_choices)
      @game.run
    end

    it "requests a move from the player" do
      set_run_loop_limit(1)
      @player1.should_receive(:choose_move)
      @game.run
    end

    it "requests marks from players until board has winning solution" do
      set_run_loop_limit(3)
      @player1.should_receive(:choose_move).exactly(2).times
      @player2.should_receive(:choose_move).exactly(1).times
      @game.run
    end

    it "#run loop alternates between players" do
      set_run_loop_limit(4)
      @tracker = []
      @game.players.each do |each|
        each.stub!(:choose_move) { @tracker << @game.players.first }
      end
      @game.run
      @tracker.should == @game.players*2
    end

    it "#run sends a clone of the board to players" do
      set_run_loop_limit(1)
      @game.board.should_receive(:clone)
      @player1.stub!(:choose_move) do |board|
        board.should_not equal @game.board
      end
      @game.run
    end

    it "#run loops request for move until move is valid" do
      set_run_loop_limit(1)
      @player1.stub!(:choose_move).and_return(0, 1, 2)
      @game.stub!(:valid_move?).and_return(false, false, false, true)
      @game.players.first.should_receive(:choose_move).exactly(3).times
      @game.run
    end
  end

  it "disallows modification to the board by players" do
    set_run_loop_limit(1)
    @player1.stub!(:choose_move) do |board|
      board.spaces = [nil, nil, nil]
      board.spaces.should_not == @game.board
    end
  end

  context "when over" do
    it "ends when the board has a winning solution" do
      @game.board.stub!(:winning_solution?).and_return(true)
      @game.over?.should == true
    end

    it "ends when the board is full" do
      @game.board.stub!(:winning_solution?).and_return(false)
      @game.board.stub!(:spaces_with_mark).and_return([])
      @game.over?.should == true
    end

    it "#run calls #display_board" do
      set_run_loop_limit(0)
      @console.should_receive(:display_board).with(@game.board)
      @game.run
    end

    it "#run calls #display_game_results" do
      set_run_loop_limit(0)
      @game.should_receive(:display_game_results)
      @game.run
    end
  end

  it "#display_game_results calls #display_game_winner if there was a winner" do
    @console.should_receive(:display_game_winner)
    @console.should_not_receive(:display_game_draw)
    @game.board.stub!(:winning_solution?).and_return(true)
    @game.display_game_results
  end

  it "#display_game_results identifies the winning symbol" do
    @game.board.stub!(:winning_solution?).and_return(true)
    @game.stub!(:winning_symbol).and_return(:player2)
    @console.should_receive(:display_game_winner).with(:player2)
    @game.display_game_results
  end

  it "#display_game_results calls #display_game_draw if there was no winner" do
    @console.should_receive(:display_game_draw)
    @console.should_not_receive(:display_game_winner)
    @game.board.stub!(:winning_solution?).and_return(false)
    @game.display_game_results
  end

  it "#winning_symbol returns the winning symbol" do
    @game.board.stub!(:winning_solution?).with(:player1).and_return(false)
    @game.board.stub!(:winning_solution?).with(:player2).and_return(true)
    @game.winning_symbol.should equal :player2
  end

  it "#winning_symbol returns nil for no winner" do
    @game.board.stub!(:winning_solution?).and_return(false)
    @game.winning_symbol.should == nil
  end

  it "#valid_move? returns true only if board space is blank" do
    @game.board.stub!(:spaces_with_mark).with(Board::BLANK).and_return([0,1,2])
    @game.valid_move?(0).should == true
    @game.valid_move?(3).should == false
  end

  private
  def stub_configuration
    @config.stub!(:players).and_return([@player1, @player2])
    @config.stub!(:console).and_return(@console)
    @config.stub!(:board).and_return(Board.new)
    @config.stub!(:assigned_symbols).
      and_return({:player1 => @player1, :player2 => @player2})
  end

  def set_run_loop_limit(limit)
    @game.stub!(:over?).and_return(*([false]*limit), true)
  end
end
