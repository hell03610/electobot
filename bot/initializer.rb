require 'logger'
require 'redis'

module App
  class << self
    def telegram_token
      raise 'A Telegram API token is needed. Set an environment variable TOKEN with the correct value.' if ENV['TOKEN'].nil?
      ENV['TOKEN']
    end

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
    end

    def logger
      Logger.new(STDOUT, Logger::DEBUG)
    end
  end
end
