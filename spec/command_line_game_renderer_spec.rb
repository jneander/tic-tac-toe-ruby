require 'command_line_game_renderer'

describe CommandLineGameRenderer do
  it "#set_output receives a reference to an output stream" do
    @renderer = CommandLineGameRenderer.new
    @renderer.set_output($stdout)
  end
end
