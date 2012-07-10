class CommandLineConsole
  attr_reader :characters

  def initialize
    @characters = Hash.new
  end

  def set_players(players)
    @characters[players.first] = "O"
    @characters[players.last] = "X"
  end
end
