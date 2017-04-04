WellReadFaker.add_source(
  :iliad,
  File.expand_path("../../books/homer_butler_iliad.txt", __FILE__),
  begin: /The quarrel between Agamemnon/,
  end: /End of the Project Gutenberg EBook of The Iliad, by Homer/,
  min_words: 5,
)

WellReadFaker.default_source = :iliad
