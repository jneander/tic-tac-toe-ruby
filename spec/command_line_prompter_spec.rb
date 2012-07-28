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
    @input.should_receive(:gets).and_return('c','b')
    @prompter.request("").should_not == 'c'
  end

  it "#request allows any input if valid input is nil" do
    @prompter.valid_input = nil
    @input.reopen("allowed", 'r+')
    @prompter.request("").should == "allowed"
  end

  it "#valid_input? returns true when input matches to 'valid_input'" do
    @prompter.valid_input = ['a','b']
    @prompter.valid_input?('a').should == true
    @prompter.valid_input?('c').should == false
  end

  it "#valid_input? returns true if 'valid_input' is not an Array" do
    @prompter.valid_input = nil
    @prompter.valid_input?("any input").should == true
  end

  it "#valid_input? returns false if input is not a String" do
    @prompter.valid_input = nil
    @prompter.valid_input?(nil).should == false
    @prompter.valid_input?(12).should == false
  end

  it "#request repeats until valid input is received" do
    @output.should_receive(:print).with("request").exactly(3).times
    @input.should_receive(:gets).and_return("bad","wrong","correct")
    @prompter.valid_input = ["correct"]
    @prompter.request("request").should == "correct"
  end
end
