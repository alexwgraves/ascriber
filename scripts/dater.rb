require 'net/http'

class Dater
  attr_accessor(:url)

  def initialize(url)
    @url = url
  end

  def getArchiveURI(url)
    "http://web.archive.org/web/timemap/json/#{url}"
  end

  def run
    wayback_json = Net::HTTP.get_response(URI.parse(getArchiveURI(@url)))
    data = wayback_json.body
    JSON.parse(data).to_s
  end

end
