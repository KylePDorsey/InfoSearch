require_relative "../../crawler/crawler"

describe Crawler do
  let(:crawler) {Crawler.new()}

  it "has an array of links to scrap" do
    crawler.links_to_scrape = ['/../test1.html']
    expect(crawler.links_to_scrape).to eq (['/../test1.html'])
  end

  it "has an array of bucket links" do
    crawler.link_bucket = ['/../test1.html']
    expect(crawler.link_bucket.class).to eq Array
  end

  it "has writes crawled links to a file" do
    crawler.link_bucket = ['/../test1.html']
    expect(crawler.link_bucket.class).to eq Array
  end
end
