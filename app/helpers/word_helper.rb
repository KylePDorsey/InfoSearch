
module WordHelper
  def self.nokogiri_to_words(nokogiri_obj)

    tag_content= []
    tags = ['title', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'li', 'a']

    tags.each do |tag|
      tag_content << nokogiri_obj.css(tag).map { |p| p.inner_text.split(" ") }
    end
    tag_content.flatten!

    words = []

    join_tag_content_for_downcase = tag_content.join(" ")
    downcased_tag_content = join_tag_content_for_downcase.downcase
    tag_content = downcased_tag_content.split(" ")
    tag_content.uniq!
    tag_content = tag_content[0..299]
    joined_content = tag_content.join(" ")
    joined_content.gsub!(/[!@&"'?.#*^+=-_%$`~|]/,'')
    puncuation_free_content = joined_content.split(" ")

    puncuation_free_content.uniq!
    puncuation_free_content.each do |word|
      words << Word.find_or_create_by(text: word)
    end
    words
  end

  def self.text_splitter(nokogiri_obj)
    tag_content= []
    tags = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'li', 'a']

    tags.each do |tag|
      tag_content << nokogiri_obj.css(tag).map { |p| p.inner_text.downcase }
    end
    tag_content.flatten.join(" ").split(" ")[0..299].join(" ")
  end

  def self.create_words(words_array)
    words = []
    words_array.each do |word|
      new_word = Word.new(text: word)
      new_word.save
      words << new_word
    end

    words
  end
end

