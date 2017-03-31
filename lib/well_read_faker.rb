require "well_read_faker/version"
require "well_read_faker/source"

module WellReadFaker

  module_function

  def sources
    @sources ||= {}
  end

  def add_source ident, path, options = {}
    sources[ident] = Source.new(path, options)
  end

  def default_source
    sources[@default_source_ident]
  end

  def default_source= ident
    @default_source_ident = ident
  end

  def paragraph
    default_source.paragraph
  end

end

require "well_read_faker/load_bundled_sources"
