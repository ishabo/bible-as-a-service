module Bible
  class Version

    attr_reader :versions_dir

    def initialize
      @versions_dir = './versions'
    end

    def available_versions
      versions = []
      Dir["#{@versions_dir}/*.rb"].each {|file| versions << file }
      versions
    end

    def load (version)
      begin
        return eval("Bible::Versions::#{version.capitalize}")
      rescue
        raise VersionMissingError.new version, available_versions
      end
    end

    class VersionMissingError < Exception

      def initialize (version, available_versions)
        @version = version
        @available_versions = available_versions
      end

      def message
        error = "The Bible #{@version} version is not yet supported. "
        error += "Versions currently available are: #{@available_versions.join(', ')}"
        error
      end
    end
  end
end
