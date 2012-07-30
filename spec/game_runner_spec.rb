require 'game_runner'
require 'command_line_prompter'
require 'command_line_renderer'
require 'command_line_console'

describe GameRunner do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @prompter = CommandLinePrompter.new
    @prompter.set_input_output(@input, @output)
    @renderer = CommandLineRenderer.new
    @renderer.set_output(@output)
    @console = CommandLineConsole.new(@prompter, @renderer)
    @config = Configuration.new(@console)
    @runner = GameRunner.new(@config)
  end

  it "#run creates a Game instance" do
    fake_game_class = mock("Game").as_null_object
    fake_game_class.should_receive(:new).with(@config).
      and_return(fake_game_class)
    @runner.run(fake_game_class)
  end
end
