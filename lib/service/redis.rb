module Service
  module Redis
    def lock(key, timeout = 3600, &block)
      redis = Rails.cache.redis

      if redis.set(key, Time.now, nx: true, px: timeout)
        begin
          yield if block_given?
        ensure
          redis.del(key)
        end
      end
    end
  end
end
