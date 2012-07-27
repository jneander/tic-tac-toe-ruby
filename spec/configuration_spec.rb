require 'configuration'

describe Configuration do
  it "initializes with a 'Console' object" do
    @console = mock("Console")
    @config = Configuration.new(@console)
    @config.console.should equal @console
  end
end
