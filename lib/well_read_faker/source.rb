require "mutex_m"

module WellReadFaker
  class Source
    include Mutex_m

    attr_reader :path_to_book

    def initialize path_to_book
      super()
      @path_to_book = path_to_book
    end

    def text
      mu_synchronize{ @text ||= load }
    end

    def paragraph
      text.sample
    end

  private

    def load
      raw = File.read path_to_book
      @text = process_raw_text raw
    end

    def process_raw_text raw
      paragraphs = raw.strip.split(/\n\s*\n/)
      paragraphs.map!{ |m| m.gsub /\s*\n\s*/, " " }
      paragraphs
    end

  end
end
