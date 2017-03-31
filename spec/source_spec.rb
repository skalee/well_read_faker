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

  describe "#paragraph" do
    subject{ source.paragraph }

    it "returns one of the paragraphs" do
      expect(source.text).to include subject
    end
  end

  it "loads source text only once in a thread-safe way" do
    expect(source).to receive(:load).once.and_wrap_original do |m|
      sleep 0.2
      m.call
    end

    threads = Array.new(2) do
      Thread.new{ source.text }
    end

    threads.each &:join
  end

  context "when initialized with option" do
    let(:source){ described_class.new path, options }
    let(:options){ {} }

    describe ":begin" do
      it "drops all the paragraphs before matching the expression" do
        options.merge! begin: /Third/
        expect(source.text.size).to eq(1)
        expect(source.text[0]).to match(/Third/)
      end

      it "raises exception when no matching line was found" do
        options.merge! begin: /Not included/
        expect{ source.text }.to raise_exception(ArgumentError)
      end

      it "loads whole text when option is nil" do
        expect(source.text[0]).to match(/First/)
      end
    end
  end

end
