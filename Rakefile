require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

desc 'Regenerate the schema files'
task :schema do
  require "json"
  
  out    = File.expand_path("../lib/har/schemas", __FILE__)
  schema = JSON.parse(File.read("schema.json"))
  
  # cleanup
  Dir[File.join(out, "*.json")].each { |f| 
    rm f
  }
  
  # generate
  schema.each do |type, schema|
    path = File.join(out, type)
    puts path
    
    File.open(path, "w") { |file|
      file << JSON.pretty_generate(schema)
    }
  end
end