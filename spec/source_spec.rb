require "spec_helper"

describe WellReadFaker::Source do

  let(:source){ described_class.new path }
  let(:path){ "spec/short_text.txt"}

  describe "#new" do
    it "accepts String as an argument" do
      source = described_class.new path
      expect(source.text[0]).to start_with("First line")
    end

    it "accepts IO as an argument" do
      text = File.read path
      io = StringIO.new text
      source = described_class.new io
      expect(source.text[0]).to start_with("First line")
    end
  end

  describe "#text" do
    subject{ source.text }
    it{ is_expected.to be_an(Array) }
    it{ is_expected.not_to be_empty }
  end

  describe "#paragraph" do
    subject{ source.paragraph }
    let(:take_many){ Array.new(take_many_size){ source.paragraph } }
    let(:take_many_size){ 1000 }

    it "returns one of the paragraphs" do
      expect(source.text).to include subject
    end

    it "returns paragraphs infinitely" do
      expect{ take_many }.not_to raise_exception
      expect(take_many.size).to eq(take_many_size)
      expect(take_many).to all be_a(String)
      expect(source.text).to include(*take_many)
    end

    it "never duplicates paragraphs before running out of them, " \
      "and after that returns the least recently used one" do
      unique_count = take_many.uniq.size
      0.upto(take_many_size) do |i|
        slice = take_many[i, unique_count]
        expect(slice.uniq).to eq(slice)
      end
    end

    describe "every possible return value" do
      subject{ take_many.to_set }

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

  it "loads source text only once in a thread-safe way" do
    expect(source).to receive(:load).once.and_wrap_original do |m|
      sleep 0.2
      m.call
    end

    retvals = []

    threads = Array.new(2) do
      Thread.new{ source.text }
    end

    threads << Array.new(2) do
      Thread.new{ retvals << source.paragraph }
    end

    threads.each &:join

    expect(retvals.uniq.size).to eq(2)
  end

  context "when initialized with option" do
    let(:source){ described_class.new path, options }
    let(:options){ {} }

    describe ":begin" do
      it "drops all the text before the first match of the given expression" do
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

    describe ":end" do
      it "drops all the text from the first match till document end, including match" do
        options.merge! end: /is in a new paragraph/
        expect(source.text.size).to eq(2)
        expect(source.text[-1]).to match(/Third/)
        expect(source.text[-1]).not_to match(/is in a new paragraph/)
        expect(source.text[-1]).not_to match(/And consists of/)
      end

      it "raises exception when no matching line was found" do
        options.merge! end: /Not included/
        expect{ source.text }.to raise_exception(ArgumentError)
      end

      it "loads whole text when option is nil" do
        expect(source.text[0]).to match(/First/)
        expect(source.text[-1]).to match(/Third/)
      end
    end

    describe ":min_words" do
      it "rejects paragraphs which have less than given words" do
        options.merge! min_words: 5
        expect(source.text.size).to eq(1)
        expect(source.text[0]).to match(/Third line/)
      end

      it "includes paragraphs which have at least given number of words" do
        options.merge! min_words: 4
        expect(source.text.size).to eq(2)
        expect(source.text[0]).to match(/First line/)
      end
    end
  end

end
