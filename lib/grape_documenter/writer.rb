module GrapeDocumenter
  # Writer
  class Writer
    def initialize(doc_structure)
      @doc_structure = doc_structure
    end

    def write_to_files!
      @doc_structure.each do |filename, contents|
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename, 'w') do |f|
          f.write(contents)
        end
      end
    end
  end
end
