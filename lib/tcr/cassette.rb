module TCR
  class Cassette
    attr_reader :name

    def initialize(name)
      @name = name

      if File.exists?(filename)
        @recording = false
        @contents = File.open(filename) { |f| f.read }
        @sessions = Marshal.load(@contents)
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
      File.open(filename, "w") { |f| f.write(Marshal.dump(@sessions)) }
    end

    protected

    def filename
      "#{TCR.configuration.cassette_library_dir}/#{name}.yaml"
    end
  end
end
