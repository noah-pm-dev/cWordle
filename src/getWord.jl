function getWord()
    wordList = String(read("validList.dat")) |> Meta.parse |> eval

    #println(wordList, "\n", length(wordList))

    return wordList[rand(1:2315)]
end

