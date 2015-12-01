require "spec_helper"

RSpec.describe Bible::Version do

  describe "#load" do

    module Bible
      module Versions
        class Asv
        end
      end
    end

    before :all do
      @bible_versions = Bible::Version.new
    end
    
    it "loads an existing version" do
      expect(@bible_versions.load('asv').inspect).to eq "Bible::Versions::Asv"
    end

    it "fails to load an non-existing version" do
      expect{ @bible_versions.load('kbp') }.to raise_error (Bible::Version::VersionMissingError)
    end
  end

  # describe "#available_versions" do
  #   it "finds an array of available versions from versions directory  " do
  #     expect(Bible::Version.available_versions).to eq ['asvd']
  #   end
  # end
end
