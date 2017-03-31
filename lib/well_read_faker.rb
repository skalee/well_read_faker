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

end
