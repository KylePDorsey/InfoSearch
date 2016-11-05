class Page < ActiveRecord::Base
  validates :url, presence: true
  validates :url, uniqueness: true

  has_many :metrics
  has_many :words, through: :metrics

  def self.add_to_index(args)
    new_page = Page.new(url: args[:url])
    p new_page
    p 2
    if new_page.save
      p new_page
      new_page.nokogiri = args[:noko_doc]
    end
    p 1
    p new_page.save
    new_page.save
  end

  def nokogiri=(nokogiri_obj)
    words_to_measure = WordHelper::nokogiri_to_words(nokogiri_obj)
    full_text = WordHelper::text_splitter(nokogiri_obj)
    self.title = nokogiri_obj.css("title").text
    self.save
    words_to_measure.each do |word_to_measure|
      position = full_text.index(word_to_measure.text) + 1
      frequency = full_text.select{ |text_word| text_word == word_to_measure.text }.count
      self.metrics.create(word: word_to_measure, first_position: position, frequency: frequency)
    end
  end
end

