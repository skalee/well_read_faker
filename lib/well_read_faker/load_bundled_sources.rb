iliad_path = File.expand_path "../../books/homer_butler_iliad.txt", __FILE__
WellReadFaker.add_source :iliad, iliad_path
WellReadFaker.default_source = :iliad
