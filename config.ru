require "./rack/live_traffic"
require "action_dispatch/middleware/remote_ip"

use ActionDispatch::RemoteIp
use Rack::LiveTraffic

app = proc do |env|
  sleep rand
  [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]
end

run app
