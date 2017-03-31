require "spec_helper"

describe WellReadFaker do
  it "has a version number" do
    expect(WellReadFaker::VERSION).not_to be nil
  end

  describe "#sources" do
    subject{ WellReadFaker.sources }

    it{ is_expected.to be_a(Hash) }

    it "contains Iliad by default" do
      expect(subject.keys).to include(:iliad)
      expect(subject[:iliad]).to be_a(WellReadFaker::Source)
      expect(subject[:iliad].text).not_to be_empty
    end
  end

  describe "#add_source" do
    subject{ WellReadFaker.add_source :short, path }
    let(:path){ "spec/short_text.txt" }

    it "instantiates a new Source and adds it to sources" do
      expect{ subject }.to change{ WellReadFaker.sources.size }.by(1)
      expect(WellReadFaker.sources[:short]).to be_a(WellReadFaker::Source)
      expect(WellReadFaker.sources[:short].text).not_to be_empty
      expect(WellReadFaker.sources[:short].text.join).to match /First line/
    end
  end
end
