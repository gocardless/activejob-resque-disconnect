require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'activejob-resque-disconnect'
  s.version = ActiveJob::QueueAdapters::RESQUE_DISCONNECT_ADAPTER_VERSION
  s.date = Date.today.strftime('%Y-%m-%d')
  s.authors = ['Isaac Seymour']
  s.email = ['isaac@isaacseymour.co.uk']
  s.summary = 'ActiveJob Resque adapter which disconnects when the job is complete'
  s.description = <<-EOL
    If you're using ActiveRecord with Resque, a new database connection will get opened
    for each worker process. When the worker completes, this connection is left open by
    default, which is pretty bad. This adapter closes the connection when the job has_rdoc
    finished executing.
  EOL
  s.homepage = 'http://github.com/gocardless/activejob-resque-disconnect'
  s.license = 'MIT'

  s.has_rdoc = false
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.require_paths = %w(lib)

  s.add_dependency('activejob', '>= 4.2')
  s.add_dependency('activerecord', '>= 4.2')
  s.add_dependency('resque')
  s.add_dependency('resque-scheduler')

  s.add_development_dependency('rake', ' >= 10.3')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-its')
  s.add_development_dependency('rubocop')
end
