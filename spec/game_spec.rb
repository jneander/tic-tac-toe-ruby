require 'game'

describe Game do
  before :each do
    @console = mock("console").as_null_object
    @game = Game.new(@console)
    @player1 = mock("player").as_null_object
  end

  context "with new board" do
    before :each do
      @game.board = stub("board").as_null_object
      @game.board.stub(:winning_solution?).and_return(false)
      @game.board.stub(:spaces_with_mark).and_return([nil]*9)
    end

    it "is not over after creation" do
      @game.over?.should eql false
    end
  end

  context "while not over" do
    before :each do
      @game.board = mock("board").as_null_object
      @game.players << @player1
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
  end

  context "with winning board" do
    it "ends when the board has a winning solution" do
      set_winning_board
      @game.over?.should eql true
    end
  end

  private
  def set_winning_board(mark = :player)
    @game.board = stub("board").as_null_object
    @game.board.stub!(:winning_solution?).and_return(true)
  end

  def set_board_marks_until_solution(mark_count = 0)
    values = [false]*mark_count + [true]
    @game.board.should_receive(:winning_solution?).and_return(*values)
    @game.board.should_receive(:spaces_with_mark).any_number_of_times.and_return([nil]*9)
  end
end
