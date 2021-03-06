module TCR
  class Cassette
    attr_reader :name

    def initialize(name)
      @name = name

      if File.exists?(filename)
        @recording = false
        @contents = File.open(filename) { |f| f.read }
        @sessions = JSON.parse(@contents)
      else
        @recording = true
        @sessions = []
      end
    end

    def recording?
      @recording
    end

    def next_session
      session = @sessions.shift
      raise NoMoreSessionsError unless session
      session
    end

    def append(session)
      raise "Can't append session unless recording" unless recording?
      @sessions << session
      File.open(filename, "w") { |f| f.write(JSON.pretty_generate(@sessions)) }
    end

    protected

    def filename
      "#{TCR.configuration.cassette_library_dir}/#{name}.json"
    end
  end
end
