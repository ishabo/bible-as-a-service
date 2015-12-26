require "spec_helper"

RSpec.describe ExhibitHelper do

  include ExhibitHelper

  describe "exhibit different formats" do
    it "converts hash to JSON by default" do
      expect(exhibit {:a => "a"}).to eq ()
    end
  end
end
