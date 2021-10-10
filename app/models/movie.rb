class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  def self.with_ratings(ratings_list, sorting)
    if ratings_list.nil?
      return Movie.all.order(sorting)
    end
    return Movie.where(rating: ratings_list).order(sorting)
  end
end
