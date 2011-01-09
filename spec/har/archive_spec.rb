require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Archive do

    context "creating archives" do
      it "can be created from a String" do
        Archive.from_string('{"log": {}}').should be_kind_of(Archive)
      end

      it "can be created from a file" do
        Archive.from_file(fixture_path("browser-blocking-time.har")).should be_kind_of(Archive)
      end
    end

    context "fetching data" do
      let(:archive) { Archive.from_file fixture_path("browser-blocking-time.har") }

      it "has a list of pages" do
        ps = archive.pages

        ps.should be_kind_of(Array)
        ps.size.should == 2

        ps.first.should be_kind_of(Page)
      end
    end

  end # Archive
end # HAR