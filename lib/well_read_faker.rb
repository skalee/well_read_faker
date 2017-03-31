require "well_read_faker/version"
require "well_read_faker/source"

module WellReadFaker

  module_function

  def sources
    @sources ||= {}
  end

  def add_source ident, path
    sources[ident] = Source.new(path)
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

iliad_path = File.expand_path "../books/homer_butler_iliad.txt", __FILE__
WellReadFaker.add_source :iliad, iliad_path
WellReadFaker.default_source = :iliad
