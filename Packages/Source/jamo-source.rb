# -*- coding: utf-8 -*-
tags = ["consonants", "vowels", "all"]
desc = ["Consonants", "Vowels", "All Characters"]
chars = [
         ['ㄱ', ['g'], ['all', 'consonants']],
         ['ㄲ', ['gg'], ['all', 'consonants']],
         ['ㄴ', ['n'], ['all', 'consonants']],
         ['ㄷ', ['d'], ['all', 'consonants']],
         ['ㄸ', ['dd'], ['all', 'consonants']],
         ['ㄹ', ['l', 'r'], ['all', 'consonants']],
         ['ㅁ', ['m'], ['all', 'consonants']],
         ['ㅂ', ['b'], ['all', 'consonants']],
         ['ㅃ', ['bb'], ['all', 'consonants']],
         ['ㅅ', ['s'], ['all', 'consonants']],
         ['ㅆ', ['ss'], ['all', 'consonants']],
         ['ㅇ', ['ng', 'x'], ['all', 'consonants']],
         ['ㅈ', ['j'], ['all', 'consonants']],
         ['ㅉ', ['jj'], ['all', 'consonants']],
         ['ㅊ', ['c'], ['all', 'consonants']],
         ['ㅋ', ['k'], ['all', 'consonants']],
         ['ㅌ', ['t'], ['all', 'consonants']],
         ['ㅍ', ['p'], ['all', 'consonants']],
         ['ㅎ', ['h'], ['all', 'consonants']],
         ['ㅏ', ['a'], ['all', 'vowels']],
         ['ㅐ', ['ae'], ['all', 'vowels']],
         ['ㅑ', ['ya'], ['all', 'vowels']],
         ['ㅒ', ['yae'], ['all', 'vowels']],
         ['ㅓ', ['eo'], ['all', 'vowels']],
         ['ㅔ', ['e'], ['all', 'vowels']],
         ['ㅕ', ['yeo'], ['all', 'vowels']],
         ['ㅖ', ['ye'], ['all', 'vowels']],
         ['ㅗ', ['o'], ['all', 'vowels']],
         ['ㅘ', ['wa'], ['all', 'vowels']],
         ['ㅙ', ['wae'], ['all', 'vowels']],
         ['ㅚ', ['oe'], ['all', 'vowels']],
         ['ㅛ', ['yo'], ['all', 'vowels']],
         ['ㅜ', ['u'], ['all', 'vowels']],
         ['ㅝ', ['weo'], ['all', 'vowels']],
         ['ㅞ', ['we'], ['all', 'vowels']],
         ['ㅟ', ['wi'], ['all', 'vowels']],
         ['ㅠ', ['yu'], ['all', 'vowels']],
         ['ㅡ', ['eu'], ['all', 'vowels']],
         ['ㅢ', ['ui', 'yi', 'eui'], ['all', 'vowels']],
         ['ㅣ', ['i'], ['all', 'vowels']]
        ]

puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"
puts "<plist version=\"1.0\">"
puts "<dict>"
puts "  <key>name</key>"
puts "  <string>Korean Jamo</string>"
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
