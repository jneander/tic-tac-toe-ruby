class GameRunner
  def initialize(config)
    @config = config
  end

  def run(game_class)
    game_class.new(@config).run
  end
end
