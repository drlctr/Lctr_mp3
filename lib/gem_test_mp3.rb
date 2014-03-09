#test mp3 program
#
#N. Woodward Mar 2014

require 'lctr_mp3_gem (0.0.0)'

if ARGV[0].nil? then 
  raise "This program requires you input a file name"
end

unless File.exists?(ARGV[0]) then 
	raise "That file does not exist!"
end

id3 = ID3.new(ARGV[0])

puts "Artist = #{id3.artist}"
puts "Album = #{id3.album_title}"
puts "Song Title = #{id3.song_title}"
puts "Year Recorded = #{id3.year}"
puts "Track = #{id3.track}"
puts "Time = #{id3.song_length}"
puts "ID3 Version = #{id3.version}"
puts "Flag Class = #{id3.flags.class}"
puts "Flags = #{id3.flags}"
puts "Path = #{id3.path}"
puts "File Name = #{id3.mp3_file}"
