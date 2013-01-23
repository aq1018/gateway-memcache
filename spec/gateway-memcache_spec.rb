require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Gateway::Memcache do
  before do
    described_class.mock_connection = double 'connection'
  end

  it "should profile a get request" do
    conn.stub('get') { true }

    subject.get 'foo'
    profiler.first.should be_a_profile_req_like name: 'tester',
                                                status: 200,
                                                desc: 'HIT',
                                                req: 'GET foo'
  end

  it 'should profile a bad get request' do
    conn.stub('get') { false }

    subject.get 'foo'
    profiler.first.should be_a_profile_req_like status: 404,
                                                desc: 'MISS',
                                                req: 'GET foo'
  end

  it "should profile a set request" do
    conn.stub('set') { true }

    subject.set 'foo', 1
    profiler.first.should be_a_profile_req_like status: 200,
                                                desc: 'HIT',
                                                req: 'SET foo'
  end

  it 'should profile a bad set request' do
    conn.stub('set') { false }

    subject.set 'foo', 1
    profiler.first.should be_a_profile_req_like status: 404,
                                                desc: 'MISS',
                                                req: 'SET foo'
  end
end
