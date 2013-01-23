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

    def set(id, value, expiration=nil, raw = false)
      opts = {:retry => false}
      ttl = expiration || default_expiration

      execute(:set, id, opts) do |conn|
        conn.set(id, value, ttl, raw)
      end
    end

    def default_expiration
      options.fetch :expiration, 0
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

    def success_status(resp)
      resp ? 200 : 404
    end

    def success_message(resp)
      resp ? 'HIT' : 'MISS'
    end
  end
end
