require 'minimax'

describe Minimax do
  it "scores high on winning move" do
    solver = Minimax.new
    player1 = mock("Player")
    board = mock("Board")
    board.should_receive(:winning_solution?).with(player1).and_return(true)
    solver.score(board,player1).should == 1
  end
end
