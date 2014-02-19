#mp3 id3 tag reader

class ID3

	attr_accessor :mp3_file, :song_title, :album_title, :artist, :track, :year

	def initialize (file)
		@header = Array.new
		File.open(file, "r") do |f|
			f.each_byte.with_index do |ch, index|
				case index
				when 0..4
			    @header << ch.chr
			  when 5..9
			  	@header << ch
			  end

			  break if index > 10
			 end
		end

		self.parse_header

	end

	#test

  def parse_header

  	print @header

		unless @header[0..2].join == "ID3"
			raise "No ID3 tag on the file"
		end

		unless @header[3..4].join(' ') == "\x03 \x00"
			raise "Incorrect ID3 version - require v2.3"
		end

		@tag_size = @header[6]*16**3 + @header[7]*16**2 + @header[8]*16 + @header[9]


		p @tag_size



	en

end

test_case=ID3.new ("02_Rumour_Has_It.mp3")

