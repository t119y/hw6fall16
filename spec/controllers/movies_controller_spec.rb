require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb) {[double('movie1'), double('movie2')]}
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results) #assigns(:movies) returns whatever value (if any) was assigned to @movies in search_tmdb, and our spec just has to verify that the controller action correctly sets up this variable. 
    end 
    it "should redirect to homepage when inputing a blank search term" do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => ' '}
      expect(response).to redirect_to(movies_path)
    end
    it "should redirect to homepage when the TMDb search does not find any movies matching the search term" do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => '"'}
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'adding TMDb' do
    it "shouldn't call Movie::create_from_tmdb if no check box is selected" do  
      expect(Movie).not_to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => nil}
    end
    it "shouldn call Movie::create_from_tmdb when check box(es) is(are) selected" do  
      expect(Movie).to receive(:create_from_tmdb).with("943")
      post :add_tmdb, {:tmdb_movies => {"943": "1"}}
    end
  end
  
end
