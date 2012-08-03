$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'configuration'
require 'command_line_console'
require 'command_line_prompter'
require 'command_line_renderer'
require 'game_runner'

console = CommandLineConsole.new($stdin, $stdout)
config = Configuration.new(console)
runner = GameRunner.new(config)
runner.run(Game)
