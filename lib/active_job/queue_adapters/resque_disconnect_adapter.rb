require 'resque'
require 'active_job'
require 'active_record'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/array/access'

begin
  require 'resque-scheduler'
rescue LoadError
  begin
    require 'resque_scheduler'
  rescue LoadError
    false
  end
end

module ActiveJob
  module QueueAdapters
    # == Resque adapter for Active Job which disconnects when the job is done
    #
    #   require 'active_job/queue_adapters/resque_disconnect_adapter'
    #   Rails.application.config.active_job.queue_adapter = ActiveJob::QueueAdapters::ResqueDisconnectAdapter
    class ResqueDisconnectAdapter
      class << self
        def enqueue(job)
          Resque.enqueue_to(job.queue_name, JobWrapper, job.serialize)
        end

        def enqueue_at(job, timestamp)
          unless Resque.respond_to?(:enqueue_at_with_queue)
            raise NotImplementedError,
                  "To be able to schedule jobs with Resque you need the " \
                  "resque-scheduler gem. Please add it to your Gemfile and run bundle " \
                  "install"
          end
          Resque.enqueue_at_with_queue(job.queue_name, timestamp, JobWrapper, job.serialize)
        end
      end

      class JobWrapper
        class << self
          def perform(job_data)
            ActiveJob::Base.execute(job_data)
          ensure
            ActiveRecord::Base.connection.disconnect!
          end
        end
      end
    end
  end
end
