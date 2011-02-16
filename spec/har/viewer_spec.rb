require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Viewer do

    context "options" do
      it "has sensible defaults" do
        v = Viewer.new([google_path])

        v.options[:port].should == 9292
        v.options[:validate].should be_false
      end

      it "parses the port option" do
        v = Viewer.new(["-p", "1234", google_path])
        v.options[:port].should == 1234
      end

      it "parses the --validate option" do
        v = Viewer.new(["--validate", google_path])
        v.options[:validate].should be_true
      end
    end

    it "validates the given HARs if asked to" do
      lambda { Viewer.new(["--validate", *all_hars]) }.should raise_error(ValidationError)
    end

    it "validates HARs read from stdin if asked to" do
      with_stdin_replaced_by(har_path("bad")) do
        lambda { Viewer.new(["--validate", "-"]) }.should raise_error(ValidationError)
      end
    end

    it "has a merged archive" do
      Viewer.new(good_hars).har.should be_kind_of(Archive)
    end

  end
end
