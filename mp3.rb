#mp3 id3 tag reader

require './mp3_frame_ids.rb'

class ID3

	attr_accessor :mp3_file, :song_title, :album_title, :artist, :track, :year, :time, :version, :flags, :path

	def initialize(file)
		unless File.exists?(file) then 
			raise "That file does not exist!"
		end
		@file = file
		header = get_tag_header 
		tag_size = parse_header(header)
		tag = get_tag(tag_size)
		get_frames(tag)
		set_file
		set_flag(header[5])
	end

	def get_tag_header
		header = Array.new
		File.open(@file, "r") do |f|
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

	def get_tag(size)
		tag = ""
		File.open(@file, "r") do |f|
			f.each_byte.with_index do |ch,index|
				tag << ch
	
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

  def tag_size(header6_9)
  	header6_9.join.to_i(2)
  end

  def get_frames(tag)
    FRAMES.keys.each do |type|

      if loc = (/#{type}/ =~ tag)
        fr_size_arr = tag[loc+4,4].bytes
        fr_size_str=""

        fr_size_arr.each do |ch|
        	fr_size_str<<ch.to_s(2).rjust(8,"0")
        end

        fr_size = fr_size_str.to_i(2)
        frm = tag[loc+10,fr_size].gsub(/\u0000/,"")

        puts "type: #{type} loc: #{loc} size:  #{fr_size} data:  #{frm}"

        eval("self.#{FRAMES[type]} = frm")


     	else
    		puts "#{type} does not exist"
    	end

    end

  end

  def set_file
  	self.path = File.dirname(@file)
  	self.mp3_file = File.basename(@file)
  	puts "path = #{self.path}"
  	puts "file = #{self.mp3_file}"
  end

  def set_flag(flags)
  	puts "flags = #{flags.to_s(2).rjust(8,"0")[0..2]} class = #{flags.class}"
  	self.flags = flags
  end


end


   @id3 = ID3.new(ARGV[0])