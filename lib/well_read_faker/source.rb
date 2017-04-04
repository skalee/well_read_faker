require "mutex_m"

module WellReadFaker
  class Source
    include Mutex_m

    attr_reader :path_to_book_or_io, :options

    def initialize path_to_book_or_io, options = {}
      super()
      @path_to_book_or_io = path_to_book_or_io
      @options = options
    end

    def text
      @text || mu_synchronize{ @text ||= load }
    end

    def paragraph
      text.sample
    end

  private

    def load
      if path_to_book_or_io.respond_to? :read
        raw = path_to_book_or_io.read
      else
        raw = File.read path_to_book_or_io
      end

      @text = process_raw_text raw
    end

    def process_raw_text raw
      trimmed = trim_text_by_regexps raw, options[:begin], options[:end]
      paragraphs = trimmed.split(/\n\s*\n/)
      paragraphs.map!{ |m| m.gsub /\s*\n\s*/, " " }
      if options[:min_words]
        paragraphs.select!{ |m| /(\w+\b\W*){#{options[:min_words]}}/ =~ m }
      end
      paragraphs
    end

    def trim_text_by_regexps source_text, begin_rx, end_rx
      retval = source_text.dup

      if begin_rx
        match_data = begin_rx.match(retval) or raise(
          ArgumentError,
          "Regular expression #{begin_rx.inspect} not found in text."
        )
        retval[0..match_data.begin(0)-1] = ""
      end

      if end_rx
        match_data = end_rx.match(retval) or raise(
          ArgumentError,
          "Regular expression #{end_rx.inspect} not found in text."
        )
        retval[match_data.begin(0)..-1] = ""
      end

      retval.strip!
      retval
    end

  end
end
