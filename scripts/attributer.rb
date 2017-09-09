class Attributer

  def self.credit!(img)
    matches = img.matching_pages
    p matches
    earliest = matches.reject { |m| m[:pubDate].empty? }
    earliest = earliest.sort_by { |m| m['pubDate'] }
    probable_og = earliest.first
    img.source_url = earliest['url']
  end
end
