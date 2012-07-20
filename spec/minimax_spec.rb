require 'minimax'

describe Minimax do
  before :each do
    @minimax = Minimax.new
  end

  it "stores references to 'min' and 'max' marks" do
    @minimax.max_mark = :MAX
    @minimax.min_mark = :MIN
  end
end
