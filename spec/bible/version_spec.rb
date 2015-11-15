require "spec_helper"

RSpec.describe Bible::Version do
  describe "#available_versions" do
    it "finds an array of available versions from versions directory  " do
      expect(Bible::Version.available_versions).to eq ['asvd']
    end
  end
end
