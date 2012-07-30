require 'player'

describe Player do
  it "#initialize with and store a symbol argument" do
    @player = Player.new(:test_symbol)
    @player.symbol.should eql :test_symbol
  end
end
