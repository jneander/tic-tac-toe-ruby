require 'game'
require 'configuration'

describe Game do
  before :each do
    @console = mock("console").as_null_object
    @config = Configuration.new(@console)
    @game = Game.new(@config)
    @board = @game.board = mock("Board").as_null_object
    @player1 = mock("player").as_null_object
    @player2 = mock("player").as_null_object
    @console.stub!(:prompt_play_again).and_return(false)
  end

  context "at initialization" do
    it "is not over" do
      @game.board.should_receive(:winning_solution?).and_return(false)
      @game.board.should_receive(:spaces_with_mark).and_return([nil]*9)
      @game.over?.should == false
    end

    it "will not have players" do
      @game.players.should == []
    end

    it "will have a Board object" do
      @game.board.should_not be_nil
    end
  end

  context "at player instantiation" do
    it "will create a new player based on user input" do
      @player2.should_receive(:new).and_return(@player2)
      @console.should_receive(:prompt_opponent_type).and_return(@player2)
      @game.run
      @game.players.last.should == @player2
    end

    it "will have two unique player objects" do
      @console.should_receive(:prompt_opponent_type).and_return(Human)
      @game.run
      @game.players.length.should eql 2
      @game.players.first.should_not == @game.players.last
      @game.players.each {|player| player.should be_instance_of(Human)}
    end

    it "will assign the console to each player object" do
      @game.run
      @game.players.each do |player|
        player.console.should == @console
      end
    end

    it "#set_players discards any previous players when called" do
      @console.stub!(:prompt_opponent_type).and_return(Human,DumbComputer)
      @game.set_players
      @game.set_players
      @game.players.length.should == 2
      @game.players.last.should be_instance_of(DumbComputer)
    end

    it "#set_players assigns marks using the console" do
      @config.stub!(:assigned_symbols).and_return({:p1 => :P1, :p2 => :P2})
      @console.should_receive(:assign_marks).with(@config.assigned_symbols)
      @game.set_players
    end
  end

  context "while in 'until over?' loop" do
    before :each do
      @config.stub!(:players).and_return([@player1, @player2])
      set_human(@player1)
    end

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
      @config.stub!(:players).and_return([@player1, @player1])
      @player1.should_receive(:choose_move).exactly(3).times
      @game.run
    end

    it "alternates between players" do
      players = [@player1,@player2]
      set_opponent(@player2)
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

    it "prompts the user to play again" do
      @board.stub!(:winning_solution?).and_return(true)
      @console.should_receive(:prompt_play_again).and_return(true, false)
      @game.run
    end

    it "#run resets the board before use" do
      @board.stub!(:winning_solution?).and_return(true)
      @console.should_receive(:prompt_play_again).and_return(false)
      @board.should_receive(:reset).once
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

  def set_human(player)
    @game.player_types[0] = player
    player.stub!(:new).and_return(player)
  end

  def set_opponent(player)
    @console.stub!(:prompt_opponent_type).and_return(player)
    player.stub!(:new).and_return(player)
  end
end
