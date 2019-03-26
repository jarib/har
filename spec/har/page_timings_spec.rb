require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe PageTimings do
    let(:timings) { Archive.from_file(google_path).pages.first.timings }

    it "defines methods for custom timings" do
      timings._custom_example.should == 123
    end
  end # PageTimings
end # HAR
