# ghetto require, since mruby doesn't have require
eval(File.read('/app/bin/config/lib/nginx_config_util.rb'))

USER_CONFIG = "/app/static.json"

def match_except(except, uri)
  return false unless except

  if Regexp.compile("^#{except}$") =~ uri
    true
  else
    false
  end
end

config      = {}
config      = JSON.parse(File.read(USER_CONFIG)) if File.exist?(USER_CONFIG)
req         = Nginx::Request.new
uri         = req.var.uri
nginx_route = req.var.route
routes      = NginxConfigUtil.parse_routes(config["routes"])

if path = routes[nginx_route]
  if match_except(path["except"], uri)
    uri
  else
    path["path"]
  end
end
