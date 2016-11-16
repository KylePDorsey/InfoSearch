## Summary
InfoSearch is an opensource internet search engine built in Ruby.

It works by building an index of webpages utilizing concurrent web
crawlers. Given a few seed URLs it will index relevant search terms
into a MongoDB database. Prioritizing title and header tags above
paragraphs, it will store up to 300 words per page. The web page view 
acts as a front end to a multi-word text score search on the database
and returns a collection of links sorted in order of relevancy.

## Dependencies

InfoSearch is know to work with the following environment:

    Ruby 2.3.1
    MongoDB 3.2.1
    Redis 3.2.5