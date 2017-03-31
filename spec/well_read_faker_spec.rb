require "spec_helper"

shared_context "stub default source" do
  let(:default_source_dbl){ instance_double("WellReadFaker::Source") }
  before do
    allow(WellReadFaker).
      to receive(:default_source).
      and_return(default_source_dbl)
  end
end

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

  describe "default source" do
    it "is Iliad by default" do
      expect(WellReadFaker.default_source).to be(WellReadFaker.sources[:iliad])
    end

    it "does include load Gutenberg Project clutter, e.g. license" do
      book_content = WellReadFaker.default_source.text.join
      expect(book_content).not_to match(/Project Gutenberg/i)
    end

    it "can be set to some other source" do
      source_dbl = instance_double("WellReadFaker::Source")
      WellReadFaker.sources[:dbl] = source_dbl
      expect{
        WellReadFaker.default_source = :dbl
      }.to change{ WellReadFaker.default_source }.to(source_dbl)
    end
  end

  describe "#paragraph" do
    include_context "stub default source"

    it "is delegated to default source" do
      str = "Paragraph string."
      expect(default_source_dbl).to receive(:paragraph).and_return(str)
      expect(WellReadFaker.paragraph).to be(str)
    end
  end
end
