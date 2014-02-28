#mp3 id3 tag reader

class ID3

	attr_reader :mp3_file, :song_title, :album_title, :artist, :track, :year, :time, :version, :flags, :path

	def initialize(file)
		header = get_header(file)
		tag_size = parse_header(header)
		tag = get_tag(file, tag_size)
    parse_tag(tag)
	end

	def get_header(file)
		header = Array.new
		File.open(file, "r") do |f|
			f.each_byte.with_index do |ch, index|
				case index
				when 0..4
			    header << ch.chr
			  when 5
			  	header << ch
			  when 6..9
			  	if ch > 128
			  		raise "Header error:  reported tag size too large"
			  	end
			  	header << ch.to_s(2).rjust(7,"0")
			  end

			  return header if index > 10
			end
		end

	end

	def get_tag(file, size)
		tag = ""
		File.open(file, "r") do |f|
			f.each_byte.with_index do |ch,index|
				tag << ch.chr
	
			  return tag if index > size
		  end
		end
	end

  def parse_header(header)
  	check_ID3(header)
  	check_ver(header)
  	return tag_size(header[6..9])
	end

	def check_ID3(header)
		unless header[0..2].join == "ID3"
			raise "No ID3 tag on the file"
		end
	end

	def check_ver(header)
		if header[3..4].join(' ') == "\x03 \x00"
			@version = "2.3"
		else
			raise "Incorrect ID3 version - require v2.3"
		end
	end

  def tag_size(header)
  	size=""
  	header.each do |entry|
  		size<<entry
  	end
  	result = size.to_i(2)
  end

  def parse_tag(tag)

end

class Frame(file,frame_id)

	attr_reader = :frame_size, :frame_contents

end

