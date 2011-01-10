require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Viewer do

    context "creating" do
      it "validates the given HARs if asked to" do
        lambda { Viewer.new(["--validate", *all_hars]) }.should raise_error(ValidationError)
      end

      it "has a merged archive" do
        Viewer.new(good_hars).har.should be_kind_of(Archive)
      end

      it "parses options" do
        v = Viewer.new(["-p", "1234", *good_hars])
        v.options[:port].should == 1234
      end
    end

  end
end