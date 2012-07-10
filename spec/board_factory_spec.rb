require 'board_factory'
require 'board'

describe BoardFactory do
  it "creates a Board instance" do
    BoardFactory.create.should be_instance_of(Board)
  end
end
