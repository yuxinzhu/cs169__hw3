# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert(page.body.index(e1) < page.body.index(e2))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  if uncheck 
    ratings.each{|rating| uncheck("ratings_" + rating)}
  else
    ratings.each{|rating| check("ratings_" + rating)}
  end
end

When /I click submit/ do
  click_on("ratings_" + "submit")
end

Then /I should (not )?see all movies with ratings: (.*)/ do |filter_out, rating_list|
  ratings = rating_list.split(', ')
  movies = []
  ratings.each{|rating| movies = movies + Movie.select{|movie| movie.rating == rating}}

  if filter_out
    movies.each{|movie| assert(!page.body.include?(movie.title))}
  else
    movies.each{|movie| assert(page.body.include?(movie.title))}
  end
end
