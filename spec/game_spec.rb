require 'game'
require 'configuration'

describe Game do
  before :each do
    @console = mock("console").as_null_object
    @config = Configuration.new(@console)
    @player1 = mock("player").as_null_object
    @player2 = mock("player").as_null_object
    @config.stub!(:players).and_return([@player1, @player2])
    @game = Game.new(@config)
    @board = @game.board = mock("Board").as_null_object
  end

  context "at initialization" do
    it "is not over" do
      @game.board.should_receive(:winning_solution?).and_return(false)
      @game.board.should_receive(:spaces_with_mark).and_return([nil]*9)
      @game.over?.should == false
    end

    it "#initialize will clone the player list from configuration" do
      @config.stub!(:players).and_return([@player1, @player2])
      @game = Game.new(@config)
      @game.players.should eql [@player1, @player2]
    end

    it "will have a Board object" do
      @game.board.should_not be_nil
    end
  end

  context "while in 'until over?' loop" do
    it "requests the console to display the board with choices" do
      set_board_marks_until_solution(1)
      @console.should_receive(:display_board_choices)
      @game.run
    end

    it "requests a move from the player" do
      set_board_marks_until_solution(1)
      @player1.should_receive(:choose_move)
      @game.run
    end

    it "requests marks from players until board has winning solution" do
      set_board_marks_until_solution(3)
      @player1.should_receive(:choose_move).exactly(2).times
      @player2.should_receive(:choose_move).exactly(1).times
      @game.run
    end

    it "alternates between players" do
      players = [@player1,@player2]
      set_board_marks_until_solution(4)
      @tracker = []
      players.each {|each| each.should_receive(:choose_move).twice {
        @tracker << @game.players.first
      }}

      @game.run
      @tracker.should == @game.players*2
    end
  end

  context "when over" do
    it "ends when the board has a winning solution" do
      set_board_marks_until_solution(0)
      @game.over?.should == true
    end

    it "ends when the board is full" do
      @board.should_receive(:winning_solution?).and_return(false)
      @board.should_receive(:spaces_with_mark).and_return([])
      @game.over?.should == true
    end

    it "#run calls #display_board" do
      @console.should_receive(:display_board).with(@board)
      @board.stub!(:winning_solution?).and_return(true)
      @game.run
    end

    it "#run calls #display_game_winner if there was a winner" do
      @console.should_receive(:display_game_winner)
      @console.should_not_receive(:display_game_draw)
      @board.stub!(:winning_solution?).and_return(true)
      @game.run
    end

    it "#run calls #display_game_draw if there was no winner" do
      @console.should_receive(:display_game_draw)
      @console.should_not_receive(:display_game_winner)
      @board.stub!(:winning_solution?).and_return(false)
      @board.stub!(:available_spaces).and_return([])
      @game.run
    end
  end

  private
  def set_board_marks_until_solution(mark_count = 0)
    values = [false]*mark_count + [true]
    @board.stub!(:winning_solution?).and_return(*values)
    @board.stub!(:spaces_with_mark).any_number_of_times
      .and_return([nil]*9)
  end
end
