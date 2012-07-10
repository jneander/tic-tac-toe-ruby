require 'command_line_console'

describe "CommandLineConsole" do
  before :each do
    @console = CommandLineConsole.new
  end

  it "assigns ASCII characters to players in 'Game'" do
    @players = [:player1,:player2]
    @console.set_players(@players)
    @console.characters[:player1].should eql 'O'
    @console.characters[:player2].should eql 'X'
  end
end
