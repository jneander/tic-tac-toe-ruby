require 'game'

describe Game do
  before :each do
    @console = mock("console").as_null_object
    @game = Game.new(@console)
    @board = @game.board = mock("Board").as_null_object
    @player1 = mock("player").as_null_object
    @player2 = mock("player").as_null_object
  end

  context "at initialization" do
    it "is not over" do
      @game.board.should_receive(:winning_solution?).and_return(false)
      @game.board.should_receive(:spaces_with_mark).and_return([nil]*9)
      @game.over?.should eql false
    end

    it "will have a Board object" do
      @game.board.should_not be_nil
    end
  end

  context "at player instantiation" do
    it "will have two unique Human objects" do
      @console.should_receive(:prompt_opponent_type).and_return(Human)
      @game.run
      @game.players.length.should eql 2
      @game.players.first.should_not eql @game.players.last
      @game.players.each {|player| player.should be_instance_of(Human)}
    end

    it "will assign the console to each Human object" do
      @game.run
      @game.players.each do |player|
        player.console.should eql @console
      end
    end

    it "prompts the user to choose an opponent" do
      @console.should_receive(:prompt_opponent_type)
      set_board_marks_until_solution(0)
      @game.run
    end
  end

  context "while in 'until over?' loop" do
    before :each do
      set_players(@player1,@player1)
    end

    it "requests the console to display the board" do
      set_board_marks_until_solution(1)
      @console.should_receive(:display_board)
      @game.run
    end

    it "requests a mark from the player" do
      set_board_marks_until_solution(1)
      @player1.should_receive(:make_mark)
      @game.run
    end

    it "requests marks from players until board has winning solution" do
      set_board_marks_until_solution(3)
      @player1.should_receive(:make_mark).exactly(3).times
      @game.run
    end

    it "alternates between players" do
      players = [@player1,@player2]
      set_players(*players)
      set_board_marks_until_solution(4)
      @tracker = []
      players.each {|each| each.should_receive(:make_mark).twice {
        @tracker << @game.players.first
      }}

      @game.run
      @tracker.should eql @game.players*2
    end
  end

  context "when over" do
    it "ends when the board has a winning solution" do
      set_board_marks_until_solution(0)
      @game.over?.should eql true
    end

    it "ends when the board is full" do
      @board.should_receive(:winning_solution?).and_return(false)
      @board.should_receive(:spaces_with_mark).and_return([])
      @game.over?.should eql true
    end

    it "requests the console to display game results" do
      set_board_marks_until_solution(0)
      @console.should_receive(:display_game_results).once
      @game.run
    end
  end

  private
  def set_board_marks_until_solution(mark_count = 0)
    values = [false]*mark_count + [true]
    @board.should_receive(:winning_solution?).and_return(*values)
    @board.should_receive(:spaces_with_mark).any_number_of_times
      .and_return([nil]*9)
  end

  def set_players(*players)
    @players = players
    @game.players = @players
  end
end
