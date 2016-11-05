require_relative "../../crawler/crawler"
require_relative "../../app/helpers/links_file_helper"

describe Crawler do
  let(:crawler) {Crawler.new(true)}

  it "has an readable attribute links_to_scrap" do
    crawler.test_seed
    crawler.links_to_scrape
    expect(crawler.links_to_scrape.class).to eq Array
  end

  it "has an readable attribute bucket_links" do
    crawler.test_seed
    crawler.scrape_all
    expect(crawler.link_bucket.class).to eq Array
  end

  it "reads crawled links to a file" do
    crawler.test_seed
    crawler.scrape_all
    expect(File.return_lines("test")).to eq (['../test_html/test1'])
  end
end
