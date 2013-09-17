require 'spec_helper'

describe MySociety::MapIt::Postcode do
  
  it "correctly normalises a postcode", :vcr do
    p = MySociety::MapIt::Postcode.new 'b46 3ld'
    p.normalised_postcode.should == "B463LD"
  end
  
  it "gives a correct lat/lng for a postcode", :vcr do
    p = MySociety::MapIt::Postcode.new 'b463ld'
    p.to_point.y.should == -1.706805276569471
    p.to_point.x.should == 52.49678940995588
  end
    
  it "gives a correct ward", :vcr do
    p = MySociety::MapIt::Postcode.new 'b463ld'
    p.ward.name.should == "Coleshill South"
  end
  
  it "gives a correct gss code for a ward", :vcr do
    p = MySociety::MapIt::Postcode.new 'b463ld'
    p.ward.gss.should == "E05007463"
  end
    
  context "two tier" do
    
    before :all, :vcr do
      @p = MySociety::MapIt::Postcode.new 'b463ld'
    end
  
    it "correctly identifies a two tier local authority", :vcr do
      @p.two_tier?.should be_true
    end
  
    it "gives a correct district council", :vcr do
      @p.district.name.should == "North Warwickshire Borough Council"
    end
    
    it "gives a correct district council gss code", :vcr do
      @p.district.gss.should == "E07000218"
    end
    
    it "gives a correct county council", :vcr do
      @p.county.name.should == "Warwickshire County Council"
    end
    
    it "gives a correct county council gss code", :vcr do
      @p.county.gss.should == "E10000031"
    end
    
    it "returns a hash when asked for a local authority", :vcr do
      @p.local_authority.kind_of?(Hash).should be_true
    end
  
  end
  
  context "single tier" do
    
    before :all, :vcr do
      @p = MySociety::MapIt::Postcode.new 'sw1a1aa'
    end
    
    it "correctly identifies a single tier local authority", :vcr do
      @p.two_tier?.should be_false
    end
    
    it "returns the correct local authority", :vcr do
      @p.local_authority.name.should == "Westminster City Council"
    end
  
    it "returns the correct local authority gss code", :vcr do
      @p.local_authority.gss.should == "E09000033"
    end
    
  end
  
  context "with parish" do
    
    it "returns the correct parish", :vcr do
      p = MySociety::MapIt::Postcode.new 'b463ld'
      p.parish.name.should == "Coleshill"
    end
    
  end
  
  context "without parish" do
    
    it "returns the nil for a parish", :vcr do
      p = MySociety::MapIt::Postcode.new 'sw1a1aa'
      p.parish.should be_nil
    end
    
  end
  
end