require 'grape_doc'

desc "Generate documentation for Grape API"
task :generate_grape_docs, [:api_class, :output_path] => :environment do |t, args|
  generator = GrapeDoc::Generator.new(args[:api_class], args[:output_path])
  generator.output
end
