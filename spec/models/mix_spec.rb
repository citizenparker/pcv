require 'spec_helper'

describe Mix do

  it "should create a new instance given valid attributes" do
    Mix.create!(Factory.attributes_for(:mix))
  end

  describe "name" do
    it "should be required" do
      mix = Factory.build(:mix, :name => nil)
      mix.save

      mix.errors.invalid?(:name).should be_true
    end

    it "should be unique" do
      mix1 = Factory(:mix)
      mix2 = Factory.build(:mix, :name => mix1.name)
      mix2.save

      mix2.errors.invalid?(:name).should be_true
    end
  end

  describe "friendly_id" do
    it "should be generated by the name" do
      mix = Factory(:mix, :name => 'I am a cool DJ.')
      mix.friendly_id.should == 'i-am-a-cool-dj'
    end

    it "should be usable as a primary key" do
      mix = Factory(:mix, :name => 'PCV turns me into a stud.')
      found_mix = Mix.find(mix.friendly_id)
      found_mix.should == mix
    end
  end

  describe "feed association" do
    it "has multiple feeds" do
      mix = Factory(:mix)
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
  
      mix.feeds << feed1
      mix.feeds << feed2


      mix = Mix.find mix.id
      mix.feeds.should include(feed1)
      mix.feeds.should include(feed2)
    end
  end

  describe "items" do
    before :each do
      @mix = Factory(:mix)
      @feed1 = Factory(:feed, :url => fake_rss_url(:mars_hill))
      @feed2 = Factory(:feed, :url => fake_rss_url(:umc))
      @mix.feeds << @feed1
      @mix.feeds << @feed2
    end

    it "mixes in items from all feeds" do
      @mix.items.size.should == 27
    end

    it "should sort the items in descending order by date" do
      sorted_items = @mix.items.dup.sort {|x,y| y.pubDate <=> x.pubDate }

      @mix.items.should == sorted_items
    end

  end
end
