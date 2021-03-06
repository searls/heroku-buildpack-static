module NginxConfigUtil
  def self.to_regex(path)
    segments = []
    while !path.empty?
      if path[0...2] == '**'
        segments << '.*'
        path = path[2..-1]
      elsif path[0...1] == '*'
        segments << '[^/]*'
        path = path[1..-1]
      else
        next_star = path.index("*") || path.length
        segments << Regexp.escape(path[0...next_star])
        path = path[next_star..-1]
      end
    end
    segments.join
  end

  def self.parse_routes(json)
    routes = json.map do |route, target|
      [to_regex(route), target]
    end

    Hash[routes]
  end

  def self.match_proxies(proxies, uri)
    return false unless proxies

    proxies.each do |proxy|
      return proxy if Regexp.compile("^#{proxy}") =~ uri
    end

    false
  end

  def self.match_redirects(redirects, uri)
    return false unless redirects

    redirects.each do |redirect|
      return redirect if redirect == uri
    end

    false
  end
end
