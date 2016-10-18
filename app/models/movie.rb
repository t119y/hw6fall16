require 'themoviedb'

class Movie < ActiveRecord::Base
  Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      if string.empty?
        return nil
      end  
      sMovie = Tmdb::Movie.find(string)
      movies = Array.new()
      if sMovie != nil
        sMovie.each do |m|
          detail = Tmdb::Movie.releases(m.id)['countries']
          detail.each do |d|
            if (m.release_date == d['release_date'])
              @rating = d["certification"]
              break
            end
          end
          movies.push({:tmdb_id => m.id, 'title' =>m.title, 'rating' => @rating, 'release_date' => m.release_date, 'description' => m.overview})
        end
      end
  
      return movies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb(m_id)
    detail = Tmdb::Movie.detail(m_id)
    @title =  detail["original_title"] || " "
    @overview = detail["overview"] || " "
    @release = detail["release_date"] || " "
    Tmdb::Movie.releases(m_id)['countries'].each do |d|
          if (@release  == d['release_date'])
            @rating = d["certification"] || " "
            break
          end
    end

    @movie = Movie.create!(:title => @title, :rating => @rating, :description => @overview, :release_date => @release )
  
  end
end


