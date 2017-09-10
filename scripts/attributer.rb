class Attributer
  def self.credit_string(matches)
    first = matches.first[:url]
    earliest = matches.reject { |m| m[:pubDate].nil? }.sort_by { |m| m[:pubDate] }
    probable_og = earliest.first
    "<a href='#{first}' target='_blank'>Most Relevant URL</a><br>
    Credit: #{scrape_credit}<br>
    <a href='#{probable_og[:url]}' target='_blank'>Possible Earliest Source</a><br>
    Credit: #{scrape_credit}<br>"
  end

  def self.scrape_credit
  end
end
