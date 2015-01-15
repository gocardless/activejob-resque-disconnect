require 'spec_helper'

RSpec.describe ActiveJob::QueueAdapters::ResqueDisconnectAdapter do
  let(:job) { double(queue_name: :queue, serialize: { 'job' => 'params' }) }

  describe ".enqueue" do
    subject(:enqueue) { described_class.enqueue(job) }

    it "enqueues to Resque" do
      expect(Resque).to receive(:enqueue_to).
        with(:queue, described_class::JobWrapper, { 'job' => 'params' })

      enqueue
    end
  end

  describe ".enqueue_at" do
    subject(:enqueue_at) { described_class.enqueue_at(job, timestamp) }
    let(:timestamp) { 'time to work' }

    it "enqueues to Resque" do
      expect(Resque).to receive(:enqueue_at_with_queue).
        with(:queue, timestamp, described_class::JobWrapper, { 'job' => 'params' })

      enqueue_at
    end
  end
end