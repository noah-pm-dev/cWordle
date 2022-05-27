using HTTP

wordList = String(HTTP.get("https://raw.githubusercontent.com/HuoKnight/cWordle/master/src/wordList.txt").body)

println(wordList)


