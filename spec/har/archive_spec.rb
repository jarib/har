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

      it "saves the archive URI if created from a file" do
        ar = Archive.from_file(fixture_path("browser-blocking-time.har"))
        ar.uri.should_not be_nil
        ar.uri.should include("browser-blocking-time.har")
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

    context "comparing" do
      it "knows when two archives are equal" do
        a = Archive.from_file fixture_path("browser-blocking-time.har")
        b = Archive.from_file fixture_path("browser-blocking-time.har")

        a.should == b
      end
    end

    context "merging" do
      it "raises a TypeError if the argument is not an Archive" do
        a = Archive.from_file fixture_path("browser-blocking-time.har")

        lambda { a.merge(1) }.should raise_error(TypeError)
        lambda { a.merge!(1) }.should raise_error(TypeError)
      end

      it "merges two archives, returning a new archive" do
        a = Archive.from_file fixture_path("browser-blocking-time.har")
        b = Archive.from_file fixture_path("google.com.har")

        c = a.merge b

        c.should_not == a
        c.should_not == b

        a.should_not == c
        b.should_not == c

        c.pages.size.should == a.pages.size + b.pages.size
        c.entries.size.should == a.entries.size + b.entries.size
      end

      it "merges one archive into the other" do
        ref = Archive.from_file fixture_path("browser-blocking-time.har")
        a   = Archive.from_file fixture_path("browser-blocking-time.har")
        b   = Archive.from_file fixture_path("google.com.har")

        # caching..
        a.pages
        a.entries

        a.merge!(b).should be_nil

        a.pages.size.should == ref.pages.size + b.pages.size
        a.entries.size.should == ref.entries.size + b.entries.size
      end

      it "adds a comment to pages about their origin" do
        a = Archive.from_file fixture_path("browser-blocking-time.har")
        b = Archive.from_file fixture_path("google.com.har")


        c = a.merge(b)

        c.pages.last.comment.should include("google.com.har")
        b.pages.last.comment.should_not include("google.com.har")
      end
    end

    context "validating" do
      let(:valid)   { Archive.from_file fixture_path("browser-blocking-time.har") }
      let(:invalid) { Archive.from_file fixture_path("bad.har") }

      it "returns true if the archive is valid" do
        valid.should be_valid
      end

      it "returns nil if the archive is valid" do
        valid.validate!.should be_nil
      end

      it "returns false if the archive is invalid" do
        invalid.should_not be_valid
      end

      it "raises an error if the archive is invalid" do
        lambda { invalid.validate! }.should raise_error(ValidationError, /bad\.har/)
      end
    end

    context "saving" do
      it "writes the archive to disk" do
        json = '{"log":{}}'
        ar   = Archive.from_string json
        out  = StringIO.new

        File.should_receive(:open).with("some.har", "w").and_yield(out)

        ar.save_to "some.har"
        out.string.should == json
      end
    end

  end # Archive
end # HAR