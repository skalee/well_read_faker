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
      mu_synchronize{ @text ||= load }
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
      paragraphs = raw.strip.split(/\n\s*\n/)
      paragraphs.map!{ |m| m.gsub /\s*\n\s*/, " " }
      while (options.key? :begin) && (paragraphs[0] !~ options[:begin])
        paragraphs.shift or raise(
          ArgumentError,
          "Regular expression #{options[:begin].inspect} not found in text."
        )
      end
      while (options.key? :end) && (paragraphs.pop !~ options[:end])
        paragraphs.empty? and raise(
          ArgumentError,
          "Regular expression #{options[:end].inspect} not found in text."
        )
      end
      paragraphs
    end

  end
end
