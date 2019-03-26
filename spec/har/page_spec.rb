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

      describe "#entries_before" do
        it "requires a DateTime" do
          expect { page.entries_before("a string") }.to raise_error(TypeError)
        end

        it "filters entries that responded before the specified time" do
          time = page.started_date_time + 0.250
          entries = page.entries_before(time)
          entries.each do |entry|
            (entry.started_date_time + entry.time / 1000.to_f).should < time
          end
        end
      end
    end
  end # Page
end # HAR