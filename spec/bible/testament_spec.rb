require "spec_helper"

RSpec.describe Bible::Testament do

  describe "#detect_testament" do

    context "when it's an old testamanet" do
      it "detects the word old" do
        expect(Bible::Testament.detect_testament "old").to eq('old_testament')
      end

      it "detects the word old_testament" do
        expect(Bible::Testament.detect_testament "old_testament").to eq('old_testament')
      end

      it "detects the word old_covenant" do
        expect(Bible::Testament.detect_testament "old_covenant").to eq('old_testament')
      end
    end
  end
end
