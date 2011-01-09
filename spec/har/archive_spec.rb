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
    end
    
    context "saving" do

    end

  end # Archive
end # HAR