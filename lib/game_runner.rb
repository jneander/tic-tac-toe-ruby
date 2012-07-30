class GameRunner
  def initialize(config)
    @config = config
  end

  def run(game_class)
    game_class.new(@config)
  end
end
