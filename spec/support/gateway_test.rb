module Gateway::Test
  class Profiler < Array
    def performance(*args)
      self << args
    end
  end
  def self.included(klass)
    klass.class_eval do
      class_attribute :mock_connection
    end
  end
  def initialize name = 'tester', opts = {}
    super
  end
  def connection_type() :test end
  def with_test() yield self.class.mock_connection end
  def profiler()
    @profiler ||= Profiler.new
  end
end

module Gateway::SpecHelper
  def profiler
    subject.profiler
  end

  def conn
    described_class.mock_connection
  end
end

RSpec::Matchers.define :be_a_profile_req_like do |expected|
  match do |name, duration, status, desc, req|
    name.should     == expected[:name]     if expected.key? :name
    duration.should == expected[:duration] if expected.key? :duration
    status.should   == expected[:status]   if expected.key? :status
    desc.should     == expected[:desc]     if expected.key? :desc
    req.should      == expected[:req]      if expected.key? :req
  end
end

RSpec.configure do |c|
  c.include Gateway::SpecHelper
end
