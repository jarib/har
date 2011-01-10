require "webrick"
require "launchy"
require "optparse"

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

      if @options[:validate]
        progress("Validating archives...") do
          hars.each { |h| h.validate! }
        end
      end

      hars
    end

    def create_root
      progress("Creating viewer...") {
        viewer = File.expand_path("../viewer", __FILE__)
        tmp_dir = Dir.mktmpdir("harviewer")

        at_exit { FileUtils.rm_rf tmp_dir }
        FileUtils.cp_r viewer, tmp_dir

        har.save_to File.join(tmp_dir, 'viewer', url_friendly(@har.uri))

        tmp_dir
      }
    end

    def merge(hars)
      progress("Merging hars...") {
        har = hars.shift or raise Error, "no HARs given"

        unless hars.empty?
          hars.each { |h| har.merge! h }
        end

        har
      }
    end

    DEFAULT_OPTIONS = {
      :port     => 9292,
      :validate => false
    }

    def parse(args)
      options = DEFAULT_OPTIONS.dup

      OptionParser.new do |opts|
        opts.banner = "Usage: har [options] [files]"

        opts.on "-p", "--port PORT", Integer do |int|
          options[:port] = int
        end

        opts.on "-v", "--version" do
          puts "har #{HAR::VERSION}"
          exit
        end

        opts.on "-w", "--validate" do
          options[:validate] = true
        end
      end.parse!(args)

      options
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
        puts "Starting server..."
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

    def progress(msg, &blk)
      print msg
      res = yield
      puts "done."

      res
    end

  end # Viewer
end # HAR