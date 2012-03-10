require "rack"
require "redis"


class Rack::LiveTraffic
  def initialize(app)
    @app = app
    @redis = Redis.connect
    @instance = rand(1e9).to_s
  end

  def call(env)
    # Fetch infos
    now = Time.now.to_i
    ip = env["action_dispatch.remote_ip"] || env["REMOTE_ADDR"]
    host = env["HTTP_HOST"]
    path = env["PATH_INFO"]

    # -> next Rack middleware
    status, headers, response = @app.call(env)
    stop = Time.now.to_i

    # Store infos in redis
    @redis.incr "requests/#{@instance}/#{now}"
    @redis.expire "requests/#{@instance}/#{now}", 300
    @redis.set "visitors/#{ip}", "1"
    @redis.expire "visitors/#{ip}", 300
    @redis.hincrby "hostnames/#{host}/#{@instance}/#{now}", path, 1
    @redis.expire "hostnames/#{host}/#{@instance}/#{now}", 300
    @redis.hincrby "slows/#{@instance}/#{now}", "#{host}#{path}", stop - now
    @redis.expire "slows/#{@instance}/#{now}", 300

    # And returns
    [status, headers, response]
  end
end
