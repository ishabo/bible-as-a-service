require "spec_helper"

RSpec.describe ExhibitHelper do

  include ExhibitHelper

  describe "exhibit different formats" do
    it "converts hash to JSON by default" do
      hash = {a: "a"}
      result = "{\"version\":1.0,\"data\":{\"a\":\"a\"}}"
      expect(exhibit hash).to eq result
    end
  end
end
