
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
   describe 'find movies in Tmdb' do
      it "should return nil if search_terms is empty" do
        search_terms = ""
        expect(Movie.find_in_tmdb(search_terms)).to be_nil
      end
      it 'should list of movies from TMDb whose titles include the search term' do
        Movie.find_in_tmdb("Lethal Weapon").each do |m| 
          expect(m["title"]).to include("Lethal Weapon")
        end
      end
   end
   
   describe 'create movie(s) that has(ve) been selected from tmdb' do
     it  "should create Movie based of tmdb_id" do
      tmdb_id=943
      expect(Movie.create_from_tmdb(tmdb_id)).not_to eq(["G", "PG", "PG-13", "NC-17", "R"])
      expect(Movie.create_from_tmdb(tmdb_id).title).to eq("Lethal Weapon 3")
    end
   end
end
