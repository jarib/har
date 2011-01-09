require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Entry do
    let(:entry) { Entry.new json(fixture_path("entry1.json"))}

    it "has a request" do
      entry.request.should be_kind_of(Request)
    end

    it "has a response" do
      entry.response.should be_kind_of(Response)
    end

  end # Entry
end # HAR