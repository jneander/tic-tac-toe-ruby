require 'command_line_prompter'

describe CommandLinePrompter do
  before :all do
    @prompter = CommandLinePrompter.new
  end

  it "receives references to input and output streams" do
    @prompter.set_input_output($stdin, $stdout)
  end

  it "prints a request" do
    @output = StringIO.new('','w')
    @prompter.set_input_output(nil, @output)
    @output.should_receive(:print)
    @prompter.request("request!")
  end
end
