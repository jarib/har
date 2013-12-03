require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Stats do
    let(:ar) { Archive.from_file(har_path("browser-blocking-time")) }
    let (:stats) { ar.stats }
    
    context 'metadata' do
      it 'has a creator' do
        stats.creator.should be_a(String)
      end

      it 'has a browser' do
        stats.browser.should be_a(String)
      end

      it 'has a source url' do
        stats.source_url.should be_a(String)
      end

      it 'has a domain' do
        stats.domain.should be_a(String)
      end

      it 'has a start time' do
        stats.started_date_time.should be_a(Time)
      end
    end

    context 'metrics' do
      it 'has page metrics' do
        [:server_time, :dom_load_time, :page_load_time, :page_size].each do |metric|
          stats.send(metric).should be_an(Integer)
        end
      end

      it 'has error metrics' do
        [:errors, :client_errors, :server_errors, :connection_errors].each do |metric|
          stats.send(metric).should be_an(Array)
          stats.send("#{metric}_count").should be_an(Integer)
        end
      end

      it 'has file type metrics' do
        [:image_files, :html_files, :css_files, :javascript_files, :flash_files, :other_files].each do |metric|
          stats.send(metric).should be_an(Array)
          stats.send("#{metric}_count").should be_an(Integer)
        end
      end

      it 'has timing metrics' do
        [:dns_time, :connect_time, :blocked_time, :wait_time, :receive_time, :send_time].each do |metric|
          stats.send(metric).should be_an(Integer)
        end
      end
    end
  end
end