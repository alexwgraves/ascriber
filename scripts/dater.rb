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
    @source = "Wayback Machine"
  end

  def getArchiveURI(url)
    "http://web.archive.org/web/timemap/json/#{url}"
  end

  def getDateList
    res = Net::HTTP.get_response(URI.parse(getArchiveURI(@url)))
    body = res.body
    json = JSON.parse(body)
    json.shift # pop off header row
    timestamps = json.map { |archive| Date.parse(archive[1]) }
    timestamps
  end

  def run
    earliest = getDateList.min
    "#{url} was first found on #{@source} on #{earliest}"
  end
end
