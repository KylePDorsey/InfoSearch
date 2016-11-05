class Crawler
  attr_accessor :links_to_scrape, :link_bucket, :current_url, :test
  def initialize(test = false)
    @links_to_scrape = []
    @test = test
    self.test_seed if test
    File.foreach(self.file_name) {|link| self.links_to_scrape << link.chomp}
    @link_bucket = []

    self.scrape_all
  end

  def file_name
    if self.test
      file_name = "test"
    else
      file_name = "links"
    end
  end

  def test_seed
    File.open(self.file_name, "w") do |f|
      f.puts('/test1')
      f.puts()
      f.puts()
    end
  end

  def scrape_all
    self.links_to_scrape[0..-2].each do |link|
      self.current_url = link
      begin
        self.scrape
      rescue
        next
      end
    end
    self.link_bucket.uniq!
    File.open(self.file_name, "w+") do |f|
      self.link_bucket.each do |link|
        f.puts(link)
      end
    end
  end

  def scrape
    if test
      local_url = 'http://127.0.0.1:9393' + current_url
      p local_url
      response = RestClient.get(local_url)
    else
      response = RestClient.get(self.current_url)
    end

    p response
    noko_doc = Nokogiri::HTML(get_response.to_s)
    page_result = Page.add_to_index(url: self.current_url, noko_doc: noko_doc)
    p page_result
    p 1
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
    p 1
    p links.reject{|link| robot.disallowed?(link) }
    self.link_bucket += links.reject{|link| robot.disallowed?(link) }
  end

end
