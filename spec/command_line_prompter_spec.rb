require 'command_line_prompter'

describe CommandLinePrompter do
  it "receives references to input and output streams" do
    @prompter = CommandLinePrompter.new
    @prompter.set_input_output($stdin, $stdout)
  end
end
