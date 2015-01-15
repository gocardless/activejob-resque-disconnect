require 'spec_helper'

RSpec.describe ActiveJob::QueueAdapters::ResqueDisconnectAdapter::JobWrapper do
  subject(:perform) { described_class.perform(job_data) }
  let(:job_data) { { 'job' => 'data' } }

  let(:connection) { double(disconnect!: true) }
  before { allow(ActiveJob::Base).to receive(:execute) }
  before { allow(ActiveRecord::Base).to receive(:connection).and_return(connection) }

  it "executes the job" do
    expect(ActiveJob::Base).to receive(:execute).with('job' => 'data')
    perform
  end

  it "disconnects from the database" do
    expect(connection).to receive(:disconnect!)
    perform
  end

  context "when the job raises" do
    before { expect(ActiveJob::Base).to receive(:execute).and_raise('hell') }

    it "still disconnects" do
      expect(connection).to receive(:disconnect!)
      expect { perform }.to raise_error(RuntimeError, 'hell')
    end
  end
end
