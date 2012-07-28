$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'command_line_console'
require 'command_line_prompter'

prompter = CommandLinePrompter.new
prompter.set_input_output($stdin, $stdout)
console = CommandLineConsole.new(prompter)
game = Game.new(console)
game.run
