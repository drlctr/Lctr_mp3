#mp3 id3 tag reader

require_relative '../lib/id3_frame_ids.rb'

#  This class represents the data held in an ID3 tag attached to an .mp3 music file.  It is intended to be a container
#  for the fields that are listed in attr_accessor and included in the file "id_frame_ids.rb" that should be held in the
#  same directory.  Upon calling the class with the name of an .mp3 file, the initialize method should pull all of the 
#  required data into the instance.  This data can later be modified and exported to a tag.
#
#  This currently works only for ID3 tags version 2.3.
#
#  ID3 technical information taken from http://id3.org/id3v2.3.0.
#
#  Author:: Neil Woodward
#  License::  MIT
#
class ID3

	attr_accessor :mp3_file, :song_title, :album_title, :artist, :track, :year, :song_length, :version, :flags, :path, :time

#  This will read in all of the tag data when the instance is initialized.
	def initialize(file)
		@file = file
		header = get_tag_header 
		tag_size = parse_header(header)
		tag = get_tag(tag_size)
		get_frames(tag)
		set_file
		set_flag(header[5])
	end

#  This reads the first 10 bytes of the tag, which contain the metadata of the tag.
	def get_tag_header
		header = Array.new
		File.open(@file, "r") do |f|
			f.each_byte.with_index do |ch, index|
				case index
				when 0..4
			    header << ch.chr
			  when 5
			  	header << ch.to_s(2)[0..2]
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

#  This will read the tag into memory and assign to the "tag" variable for later scraping.
	def get_tag(size)
		tag = ""
		File.open(@file, "r") do |f|
			f.each_byte.with_index do |ch,index|
				tag << ch
	
			  return tag if index > size
		  end
		end
	end

#  This is the method that will parse the ID3 header, making sure that it is actually a good ID3 header.
  def parse_header(header)
  	check_ID3(header)
  	check_ver(header)
  	return tag_size(header[6..9])
	end

#  This method verifies the header is indeed an ID3 header.
	def check_ID3(header)
		unless header[0..2].join == "ID3"
			raise "No ID3 tag on the file"
		end
	end

#  This method ensures that we have the correct ID3 version.
	def check_ver(header)
		if header[3..4].join(' ') == "\x03 \x00"
			@version = "2.3"
		else
			raise "Incorrect ID3 version - require v2.3"
		end
	end

#  This method converts the size bytes in the header into a decimal number representation of the header size.
  def tag_size(header6_9)
  	header6_9.join.to_i(2)
  end

#  This method is used to search the tag for the desired frame tags, and identify the frame locations and sizes.
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

        eval("self.#{FRAMES[type]} = frm")

     	else
    		eval("self.#{FRAMES[type]} = nil")
    	end

    end

  end

#  Used to set the file name.
  def set_file
  	@path = File.dirname(@file)
  	@mp3_file = File.basename(@file)
  end

#  Used to set the flag bits.
  def set_flag(flags)
  	@flags = flags
  end

end