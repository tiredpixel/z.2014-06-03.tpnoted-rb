require 'json'
require 'rack/parser'

require './lib/tpnoted/web'

use Rack::Parser, :content_types => {
  'application/json' => Proc.new { |body| JSON.parse(body) }
}

run Tpnoted::Web
