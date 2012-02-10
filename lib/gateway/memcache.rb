require 'gateway'
require 'memcache'

module Gateway
  class Memcache < Base
    categorize_error MemCache::MemCacheError,
                     :as => :bad_gateway

    def get(id, raw = false)
      opts = {:retry => false}
      execute(:get, id, opts) do |conn|
        conn.get(id, raw)
      end
    end

    def set(id, value, expiration=0, raw = false)
      opts = {:retry => false}
      execute(:set, id, opts) do |conn|
        conn.set(id, value, expiration, raw)
      end
    end

    protected

    def connect
      client = MemCache.new(
        :timeout        => options[:socket_timeout],
        :multithread    => false,  # thread safty managed by gateway
      )
      client.servers = options[:servers]
      client
    end

    def disconnect(conn)
      # let memcache client control when to retry
      # external control only making things worse
      #conn.close
    end

    def reconnect(conn)
      # let memcache client control when to retry
      # external control only making things worse
      #conn.reset
    end
  end
end
