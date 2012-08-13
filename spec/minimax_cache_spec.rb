require 'minimax_cache'

describe MinimaxCache do
  before :each do
    @cache = MinimaxCache.new
  end

  it "#initialize creates an empty hash in reader attribute" do
    @cache.map.should == {}   
  end

  it "#add_score stores a pair in the 'map' attribute" do
    @cache.add_score([:foo, :bar], 1)
    @cache.map.keys.should include([:foo, :bar])
    @cache.map[[:foo, :bar]].should == 1
  end

  it "#get_score retrieves the score associated with the spaces argument" do
    @cache.add_score([:foo, :bar], -1)
    @cache.get_score([:foo, :bar]).should == -1
  end

  it "#scored? returns true if spaces argument is scored" do
    @cache.scored?([:foo, :bar]).should == false
    @cache.add_score([:foo, :bar], 1)
    @cache.scored?([:foo, :bar]).should == true
  end
end
