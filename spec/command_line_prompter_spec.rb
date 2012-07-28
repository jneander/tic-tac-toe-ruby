require 'command_line_prompter'

describe CommandLinePrompter do
  before :all do
    @prompter = CommandLinePrompter.new
  end

  before :each do
    @input = StringIO.new('input!','r+')
    @output = StringIO.new('','w')
    @prompter.set_input_output(@input, @output)
  end

  it "prints a request to output" do
    @output.should_receive(:print)
    @prompter.request("request!")
  end

  it "#request accepts a variable number of arguments" do
    @output.should_receive(:print).with("foo","bar")
    @prompter.request("foo","bar")
  end

  it "receives string from input" do
    @prompter.request("").should == "input!"
  end

  it "receives array of valid inputs" do
    @prompter.valid_input = ['a','b']
  end

  it "#request refuses invalid input from stream" do
    @prompter.valid_input = ['a','b']
    @input.reopen('c', 'r+')
    @prompter.request("").should_not == 'c'
  end

  it "#request allows any input if valid input is nil" do
    @prompter.valid_input = nil
    @input.reopen("allowed", 'r+')
    @prompter.request("").should == "allowed"
  end
end
