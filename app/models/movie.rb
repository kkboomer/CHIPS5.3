class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? or ratings_list.empty?
      # return all movies
      Movie.all
    end
    Movie.where(rating: ratings_list)
  end
end
