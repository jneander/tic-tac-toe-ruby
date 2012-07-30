$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'command_line_console'
require 'command_line_prompter'
require 'command_line_renderer'

prompter = CommandLinePrompter.new
prompter.set_input_output($stdin, $stdout)
renderer = CommandLineRenderer.new
renderer.set_output($stdout)
console = CommandLineConsole.new(prompter, renderer)
game = Game.new(console)
game.run
