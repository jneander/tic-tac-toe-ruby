class GameRunner
  def initialize(config)
    @config = config
  end

  def run(game_class)
    keep_playing = true
    while keep_playing
      @config.setup
      game_class.new(@config).run
      keep_playing = @config.console.prompt_play_again
    end
  end
end
