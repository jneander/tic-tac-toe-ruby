class GameRunner
  def initialize(config)
    @config = config
  end

  def run(game_class)
    game_class.new(@config).run
    @config.console.prompt_play_again
  end
end
