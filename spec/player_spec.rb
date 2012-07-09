require 'player'

describe Player do
  before :each do
    @console = mock("console")
    @board = mock("board")
    @player = Player.new
    @player.console = @console
  end

  it "requests mark information from the console" do
    @console.should_receive("prompt_player_mark").and_return(0)
    @player.make_mark(@board)
  end
end
