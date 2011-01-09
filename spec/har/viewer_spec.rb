require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Viewer do

    context "creating" do
      it "validates the given HARs" do
        lambda { Viewer.new(all_hars) }.should raise_error(JSON::ValidationError)
      end

      it "has a merged archive" do
        Viewer.new(good_hars).har.should be_kind_of(Archive)
      end
    end

  end
end