class Crawler
  attr_accessor :links_to_scrape, :link_bucket, :current_url, :test
  def initialize
    @links_to_scrape = []
    File.foreach("links") {|link| self.links_to_scrape << link.chomp}
    @link_bucket = []
    @self.test = false

    self.scrape_all

  end

  def scrape_all
    links_to_scrape[0..-2].each do |link|
      self.current_url = link
      begin
        self.scrape
      rescue
        next
      end
    end
    self.link_bucket.uniq!
    if self.test
      file_name = "text"
    else
      file_name = "links"
    end
    File.open(file_name, "w+") do |f|
      self.link_bucket.each {|link| f.puts(link)}
    end
  end

  def scrape
    get_response = RestClient.get(self.current_url)
    noko_doc = Nokogiri::HTML(get_response.to_s)
    page_result = Page.add_to_index(url: self.current_url, noko_doc: noko_doc)
    p page_result
    if page_result
      parse_links(noko_doc)
    end
  end

  def url_relative?(url)
    !url.match(/^https?:\/\//i)
  end

  def concat_relative(parent, link)
    return link unless url_relative?(link)
    if link[0] == "/"
      parent + link[1..-1]
    else
      parent + link
    end
  end

  def parse_links(noko_doc)
    parent_directory = self.current_url[0..self.current_url.rindex("/")]
    links = noko_doc.css('a').map{ |link| link ["href"] }
    links.map!{ |link| concat_relative(parent_directory, link) }
    links.uniq!
    robot = WebRobots.new('MyBot/1.0')
    self.link_bucket += links.reject{|link| robot.disallowed?(link) }
  end

end
