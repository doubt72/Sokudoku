# -*- coding: utf-8 -*-
tags = ["a", "b", "both"]
desc = ["Set A", "Set B", "All Characters"]

chars = [
         ['a', ['a'], ['a', 'both']],
         ['b', ['b'], ['b', 'both']],
         ['ab', ['ab'], ['b', 'both']]
        ]

puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"
puts "<plist version=\"1.0\">"
puts "<dict>"
puts "  <key>name</key>"
puts "  <string>Test Package</string>"
puts "  <key>tags</key>"
puts "  <array>"
tags.each do |tag|
  puts "    <string>#{tag}</string>"
end
puts "  </array>"
puts "  <key>tagDescriptions</key>"
puts "  <array>"
desc.each do |d|
  puts "    <string>#{d}</string>"
end
puts "  </array>"
puts "  <key>characters</key>"
puts "  <array>"
chars.each do |char|
  puts "    <dict>"
  puts "      <key>literal</key>"
  puts "      <string>#{char[0]}</string>"
  puts "      <key>pronunciations</key>"
  puts "      <array>"
  char[1].each do |pron|
    puts "        <string>#{pron}</string>"
  end
  puts "      </array>"
  puts "      <key>tags</key>"
  puts "      <array>"
  char[2].each do |tag|
    puts "        <string>#{tag}</string>"
  end
  puts "      </array>"
  puts "    </dict>"
end
puts "  </array>"
puts "</dict>"
puts "</plist>"
