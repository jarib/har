require "webrick"
require "launchy"

module HAR
  class Viewer
    attr_reader :options, :har

    def initialize(args)
      @running = false
      @options = parse(args)

      @har = merge archives_from(args)
    end

    def show
      s = server(create_root)
      launch_browser
      s.join
    end

    private

    def archives_from(hars)
      hars = hars.map { |path| Archive.from_file(path) }
      hars.each { |h| h.validate! }
    end

    def create_root
      viewer = File.expand_path("../viewer", __FILE__)
      tmp_dir = Dir.mktmpdir("harviewer")

      at_exit { FileUtils.rm_rf tmp_dir }
      FileUtils.cp_r viewer, tmp_dir

      har.save_to File.join(tmp_dir, 'viewer', url_friendly(@har.uri))

      tmp_dir
    end

    def merge(hars)
      har = hars.shift or raise Error, "no HARs given"

      unless hars.empty?
        hars.each { |h| har.merge! h }
      end

      har
    end

    DEFAULT_OPTIONS = {
      :port => 9292
    }

    def parse(args)
      # TODO: parse command line
      DEFAULT_OPTIONS.dup
    end

    def url
      "http://localhost:#{port}/viewer/index.html?path=#{url_friendly @har.uri}"
    end

    def port
      @options[:port]
    end

    def url_friendly(str)
      str.gsub(/\W/, '_').gsub("_har", ".har")
    end

    def start_hook
      lambda { @running = true }
    end

    def server(root)
      Thread.new do
        puts "Starting HAR Viewer Server..."
        puts "Type ^C to exit\n\n"

        server = WEBrick::HTTPServer.new(:Port          => port,
                                         :DocumentRoot  => root,
                                         :StartCallback => start_hook)

        [:INT, :TERM].each do |signal|
          trap(signal) { server.shutdown }
        end

        server.start
      end
    end

    def launch_browser
      sleep 0.1 until @running
      Launchy.open url
    end

  end # Viewer
end # HAR