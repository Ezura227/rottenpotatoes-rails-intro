class Movie < ActiveRecord::Base
    def with_ratings (ratings)
        Movie.where({rating: ratings})
    end
end
