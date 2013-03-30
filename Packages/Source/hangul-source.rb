# -*- coding: utf-8 -*-
tags = ["vowel", "initial", "simple", "compound", "all"]
desc = ["Simple Vowels", "Initial Only", "Simple Final", "Complex Final", "All Hangul"]

base = 0xAC00

initial = ["g", ["gg", "kk"], "n", "d", ["dd", "tt"], ["r", "l"],
           "m", "b", ["bb", "pp"], "s", "ss", ["", "x"], "j", "jj",
           ["c", "ch"], "k", "t", "p", "h"];

medial = ["a", "ae", "ya", "yae", "eo", "e", "yeo", "ye", "o",
          "wa", "wae", "oe", "yo", "u", "weo", "we", "wi",
          "yu", "eu", ["ui", "yi", "eui"], "i"]

final = ["", ["g", "k"], ["gg", "kk", "k"], ["gs", "k"], "n", ["nj", "n"],
         ["nh", "n"], ["d", "t"], ["l", "r"], ["lg", "rg", "k"],
         ["lm", "rm", "m"], ["lb", "rb", "l"], ["ls", "rs", "l"],
         ["lt", "rt", "l"], ["lp", "rp", "p"], ["lh", "rh", "l"],
         "m", ["b", "p"], ["bs", "p"], ["s", "t"], ["ss", "t"],
         "ng", ["j", "t"], ["c", "ch", "t"], "k", "t", "p", ["h", "t"]]

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

      ctags = []
      if (i_jamo == ["", "x"] && f_jamo == [""])
        ctags = ["vowel"]
      elsif (f_jamo == [""])
        ctags = ["initial"]
      elsif (f_jamo.include?("gs") || f_jamo.include?("nj") ||
             f_jamo.include?("nh") || f_jamo.include?("lg") ||
             f_jamo.include?("lm") || f_jamo.include?("lb") ||
             f_jamo.include?("ls") || f_jamo.include?("lt") ||
             f_jamo.include?("lp") || f_jamo.include?("lh") ||
             f_jamo.include?("bs"))
        ctags = ["compound"]
      else
        ctags = ["simple"]
      end

      ctags.push("all")
      chars.push([char, pron, ctags])
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
