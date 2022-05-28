function getWord()
    wordList = String(HTTP.get("https://raw.githubusercontent.com/HuoKnight/cWordle/master/wordList.txt").body) |> Meta.parse |> eval

    #println(wordList, "\n", length(wordList))

    return wordList[rand(1:2315)]
end

