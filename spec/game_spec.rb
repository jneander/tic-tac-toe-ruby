require 'game'

describe Game do
  before :each do
    @console = mock("console").as_null_object
    @game = Game.new(@console)
    @player1 = mock("player").as_null_object
    @player2 = mock("player").as_null_object
  end

  context "at creation" do
    before :each do
      @game.board = stub("board").as_null_object
      @game.board.stub(:winning_solution?).and_return(false)
      @game.board.stub(:spaces_with_mark).and_return([nil]*9)
    end

    it "is not over" do
      @game.over?.should eql false
    end

    it "will get two Player objects via factory at initialization" do
      @game.players.length.should eql 2
      @game.players.first.should be_instance_of(Player)
      @game.players.last.should be_instance_of(Player)
    end

     it "will assign the console to initialized players" do
       @game.players.each do |player|
         player.console.should_not be_nil
       end
     end
  end

  context "while not over" do
    before :each do
      @game.board = mock("board").as_null_object
      set_one_player_game
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

    it "requests the console to display the board" do
      set_board_marks_until_solution(1)
      @console.should_receive(:display_board)
      @game.run
    end

    it "alternates between players" do
      set_two_player_game
      set_board_marks_until_solution(1)
      @game.players.first.should eql @player1
      @game.run
      @game.players.first.should eql @player2
    end
  end

  context "when over" do
    before :each do
      @game.board = mock("board")
    end

    it "ends when the board has a winning solution" do
      set_board_marks_until_solution(0)
      @game.over?.should eql true
    end

    it "ends when the board is full" do
      @game.board.should_receive(:winning_solution?).and_return(false)
      @game.board.should_receive(:spaces_with_mark).and_return([])
      @game.over?.should eql true
    end

    it "requests the console to display game results" do
      set_board_marks_until_solution(0)
      set_one_player_game
      @console.should_receive(:display_game_results).once
      @game.run
    end
  end

  private
  def set_one_player_game
    @game.players = [@player1]
  end

  def set_two_player_game
    @game.players = [@player1,@player2]
  end

  def set_board_marks_until_solution(mark_count = 0)
    values = [false]*mark_count + [true]
    @game.board.should_receive(:winning_solution?).and_return(*values)
    @game.board.should_receive(:spaces_with_mark).any_number_of_times.and_return([nil]*9)
  end
end
