module HAR
  class Stats
    attr_reader :har

    def initialize archive
      @har = archive
    end

    def creator
      @creator ||= "#{har.creator['name']} #{har.creator['version']}"
    end

    def browser
      @browser ||= "#{har.browser['name']} #{har.browser['version']}"
    end

    def started_date_time
      @started_date_time ||= pages.first.startedDateTime rescue Time.now
    end

    def source_url
      @source_url ||= get_source_url
    end

    def domain
      @domain ||= get_host(source_url)
    end

    def request_urls
      @request_urls ||= requests.map(&:url)
    end

    def domains
      @domains ||= requests.map(&:domain).uniq
    end

    def entries_count
      @entries_count ||= entries.count
    end

    def server_time
      @server_time ||= calculate_server_time
    end

    def dom_load_time
      @dom_load_time ||= pages.first.timings.on_content_load
    end

    def page_load_time
      @page_load_time ||= pages.first.timings.on_load
    end

    def page_size
      @page_size ||= sum_file_size_of_type :all
    end

    def errors
      @errors ||= files_of_type(:error)
    end

    def errors_count
      @errors_count ||= count_files_of_type(:error)
    end

    [:client, :connection, :server].each do |error_type|
      define_method("#{error_type}_errors") { files_of_type("#{error_type}_error") }
      define_method("#{error_type}_errors_count") { count_files_of_type("#{error_type}_error") }
    end

    [:image, :html, :css, :javascript, :flash, :other].each do |content_type|
      define_method("#{content_type}_files".to_sym) { files_of_type(content_type) }
      define_method("#{content_type}_files_count".to_sym) { count_files_of_type(content_type) }
      define_method("#{content_type}_files_size".to_sym) { sum_file_size_of_type(content_type) }
    end

    [:dns, :connect, :wait, :blocked, :send, :receive].each do |timing_type|
      define_method("#{timing_type}_time".to_sym) { sum_timings_of_type(timing_type) }
    end

    protected

    def entries
      @entries ||= har.entries
    end

    def pages
      @pages ||= har.pages
    end

    def requests
      @requests ||= entries.map(&:request)  
    end

    def responses
      @responses ||= entries.map(&:response)
    end

    def timings
      @timings ||= entries.map(&:timings)
    end

    def files_of_type type
      responses.select {|r| r.send("is_#{type}?")}
    end

    def count_files_of_type type
      files_of_type(type).count
    end

    def sum_file_size_of_type type
      type == :all ? responses.map(&:body_size).reduce(:+) : files_of_type(type).map(&:body_size).reduce(:+)
    end

    def timings_of_type type
      timings.map(&type.to_sym)
    end

    def sum_timings_of_type type
      timings_of_type(type).reduce(:+)
    end

    def calculate_server_time
      pages.first.is_redirect? ? (entries.first.timings.wait + entries[1].timings.wait) : entries.first.timings.wait
    end

    def get_source_url
      pages.first.is_redirect? ? entries[1].request.url.slice(0, 255) : entries.first.request.url.slice(0, 255)
    end

    def get_host url
      URI.parse(url).host
    end
  end
end