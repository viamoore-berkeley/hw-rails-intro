class Movie < ApplicationRecord
  
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings ratings
    if ratings == nil
      return Movie.all
    end
    return Movie.where(rating: ratings)
  end
end
