$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'command_line_console'

console = CommandLineConsole.new
game = Game.new(console)
game.run
