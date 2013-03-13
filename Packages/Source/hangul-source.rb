# -*- coding: utf-8 -*-
tags = ["all"]
desc = ["Hangul"]

base = 0xAC00

initial = ["g", "gg", "n", "d", "dd", ["r", "l"], "m", "b", "bb",
           "s", "ss", ["", "x"], "j", "jj", "c", "k", "t", "p", "h"];

medial = ["a", "ae", "ya", "yae", "eo", "e", "yeo", "ye", "o",
          "wa", "wae", "oe", "yo", "u", "weo", "we", "wi",
          "yu", "eu", ["ui", "yi", "eui"], "i"]

final = ["", "g", "gg", "gs", "n", "nj", "nh", "d", ["l", "r"],
         ["lg", "rg"], ["lm", "rm"], ["lb", "rb"], ["ls", "rs"],
         ["lt", "rt"], ["lp", "rp"], ["lh", "rh"], "m", "b", "bs",
         "s", "ss", "ng", "j", "c", "k", "t", "p", "h"]

chars = []

initial.each do |i_jamo|
  medial.each do |m_jamo|
    final.each do |f_jamo|
      char = [base].pack('U*')

      pron = []
      if (i_jamo.class == String)
        i_jamo = [i_jamo]
      end
      if (m_jamo.class == String)
        m_jamo = [m_jamo]
      end
      if (f_jamo.class == String)
        f_jamo = [f_jamo]
      end

      i_jamo.each do |ix|
        m_jamo.each do |mx|
          f_jamo.each do |fx|
            pron.push(ix + mx + fx)
          end
        end
      end

      base += 1

      chars.push([char, pron, ["all"]])
    end
  end
end

puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"
puts "<plist version=\"1.0\">"
puts "<dict>"
puts "  <key>name</key>"
puts "  <string>Korean Hangul</string>"
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