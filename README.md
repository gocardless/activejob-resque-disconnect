# ActiveJob::QueueAdapters::ResqueDisconnectAdapter

ActiveJob adapter for Resque which disconnects when the worker has finished.

By default the connection will be left open until the database times it out, which eats up
database connections for no good reason.

```ruby
require 'active_job/queue_adapters/resque_disconnect_adapter'

MyApp::Application.configure do
  config.active_job.queue_adapter = ActiveJob::QueueAdapters::ResqueDisconnectAdapter
end
```
