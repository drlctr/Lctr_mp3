#
#mp3 ID3 tag decoding code.
#
#N. Woodward, 18 Feb 2014

require "#{File.dirname(__FILE__)}/mp3.rb"

describe ID3 do

  before (:each) do
    @id3 = ID3.new("02_Rumour_Has_It.mp3")
  end
	
  it "should correctly identify the Artist" do
  	@id3.artist.should eq "Adele"
  end

  it "should correctly identify the album"  do
  	@id3.album_title.should eq "21"
  end

  it "should correctly idenfity the song" do
  	@id3.song_title.should eq "Rumour Has It"
  end

  it "should correctly idenfity the track number" do
  	@id3.track.should eq 2
  end

  it "should correctly idenfity the file name of the song" do
  	@id3.mp3_file.should eq "02_Rumour_Has_It.mp3"
  end

  it "should correctly identify the path to the file" do
  	@id3.path.should eq XXX
  end

  it "should correctly identify the year of the song" do
  	@id3.path.should eq "2011"
  end

  it "should correctly identify the length of the song" do
  	@id3.time.should eq "YYY"
  end

  it "should correctly identify the ID3 flags" do
  	@id3.flags.should eq "XXX00000"
  end

  it "should correctly identify the ID3 tag version" do
  	@id3.version.should eq "2.3"
  end
  






end