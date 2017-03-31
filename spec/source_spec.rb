require "spec_helper"

describe WellReadFaker::Source do

  let(:source){ described_class.new path }
  let(:path){ "spec/short_text.txt"}

  describe "#text" do
    subject{ source.text }
    it{ is_expected.to be_an(Array) }
    it{ is_expected.not_to be_empty }
  end

  describe "every element of #text" do
    subject{ source.text }

    it "includes some non-whitespace characters" do
      is_expected.to all match /\S/
    end

    it "has no leading nor trailing whitespaces" do
      is_expected.to all match(/\A\S/) & match(/\S\z/)
    end

    it "has no new line characters" do
      is_expected.to all exclude "\n"
    end
  end

end
