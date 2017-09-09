require 'net/http'

# [
#  "urlkey",
#  "timestamp",
#  "original",
#  "mimetype",
#  "statuscode",
#  "digest",
#  "redirect",
#  "robotflags",
#  "length",
#  "offset",
#  "filename"
# ],
# Timestamp is in format yyyyMMddhhmmss

class Dater
  attr_accessor(:source)
  attr_accessor(:url)

  def initialize(url)
    @url = url
    @source = 'Wayback Machine'
  end

  def get_archive_url(url)
    "http://web.archive.org/web/timemap/json/#{url}"
  end

  def date_list
    res = Net::HTTP.get_response(URI.parse(get_archive_url(@url)))
    p get_archive_url(@url)
    body = res.body
    json = JSON.parse(body)
    json.shift # pop off header row
    timestamps = json.map { |archive| archive[1] == nil ? Date.now : Date.parse(archive[1]) }
    timestamps
  end

  def earliest
    date_list.min
  end
end
