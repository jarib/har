require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Page do

    context "data" do
      let(:page) { Archive.from_file(google_path).pages.first }

      it "has entries" do
        page.entries.size.should == 5
        page.entries.each { |e| e.pageref.should == page.id }
      end

      it "has a title" do
        page.title.should == 'Google'
      end

      it "has a PageTimings instance" do
        page.timings.should be_kind_of(PageTimings)
      end
    end

  end # Page
end # HAR