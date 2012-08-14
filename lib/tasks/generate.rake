require 'grape_doc'

desc "Generate documentation for Grape API"
task :generate_grape_docs, [:output_path, :api_class] => :environment do |t, args|
  generator = GrapeDoc::Generator.new(args[:api_class], args[:output_path])
  generator.output
end
