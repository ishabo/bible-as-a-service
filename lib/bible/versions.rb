module Bible
  module Versions

    def self.load(version)
      begin
        return eval("Bible::Versions::#{version.capitalize}")
      rescue Exception => e
        error = "The Bible #{version} version is not yet supported."
        error += "Versions currently available are: #{available_versions.join(', ')}"
        return error
      end
    end

    def self.available_versions
      versions = []
      Dir["#{VERSIONS_DIR}/*.rb"].each {|file| versions << file }
      versions
    end
  end
end
