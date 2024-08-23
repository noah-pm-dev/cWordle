#! /usr/bin/env -S julia --handle-signals=no

# haha nice comments past self, you suck

using Printf

wd = @__DIR__

function matchIndex(num, arr)
	for i in arr
		if num == i
			return true
		end
	end
	return false
end

function greenPass(input, inputPOS)
	for i in 1:5
		if input[i] == word[i]
			lettersChecked[input[i]] += 1
			push!(greenIndex, i)
			@printf("\u001b[42m%s\u001b[49m", input[i])
			if greenList[input[i]] != true
				greenList[input[i]] = true
				for (index, letter) in enumerate(letters)
					if letter == input[i]
						letters[index] = "\u001b[42m" * letter * "\u001b[49m"
					elseif occursin('[', string(letter))
						if letter[6] == input[i]
							letters[index] = "\u001b[42m" * input[i] * "\u001b[49m"
						end
					end
				end
			end
		else
			@printf("\u001b[1C")
			push!(greenIndex, 0)
		end
	end
end

function wrongPass(input, inputPOS)
	@printf("\u001b[5D")
	for i in 1:5
		if matchIndex(i, greenIndex) != true
			if occursin(input[i], join(word)) && lettersChecked[input[i]] < lettersUsed[input[i]]
				lettersChecked[input[i]] += 1
				@printf("\u001b[43m%s\u001b[49m", input[i])
				if orangeList[input[i]] != true
					orangeList[input[i]] = true
					try
						letters[findfirst(isequal(input[i]), letters)] = "\u001b[43m" * letters[findfirst(isequal(input[i]), letters)] * "\u001b[49m"
					catch e
						continue
					end
				end
			else
				@printf("\u001b[100m%s\u001b[49m", input[i])
				if greyList[input[i]] != true
					greyList[input[i]] = true
					try
						letters[findfirst(isequal(input[i]), letters)] = "\u001b[100m" * letters[findfirst(isequal(input[i]), letters)] * "\u001b[49m"
					catch e
						continue
					end
				end
			end
		else
			@printf("\u001b[1C")
		end
	end
end

print("\u001b[2J\u001b[H")

wordList = String(read("wordList.dat")) |> Meta.parse |> eval
validList = String(read("$wd/validList.dat")) |> Meta.parse |> eval
validList = append!(validList, wordList)
word = [char for char in wordList[rand(1:2315)]]
lettersUsed = Dict{Char, Any}()
lettersChecked = Dict{Char, Any}()
greenIndex = []
greenList = Dict{Char, Bool}()
orangeList = Dict{Char, Bool}()
greyList = Dict{Char, Bool}()
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', "\n", 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', "\n", 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
winStatus = 0
iter = 0

for i in letters
	if i != "\n"
		greenList[i] = false
		orangeList[i] = false
		greyList[i] = false
	end
end

print("\n\n\n\n\n\n\n\n\n$(join(letters))\u001b[1A\u001b[1F\u001b7\u001b[8A\u001b[1F")


for i in 1:6
	@label redo_input
	global iter = 0
	input = join([char for char in readline()])
	if length(input) != 5
		print("\u001b[1F\u001b[5;31m$(join(input))")
		sleep(1.5)
		print("\u001b[1K\r\u001b[0m\u001b[10D")
		@goto redo_input
	end
	for word in validList
		global iter += 1
		if word == input
			validStatus = 1
			break
		end
		if iter == 12984
			print("\u001b[1F\u001b[5;31m$(input)")
			sleep(1.5)
			print("\u001b[1K\r\u001b[0m\u001b[10D")
			@goto redo_input
		end
	end

	print("\u001b[1F")
	for i in word				
		lettersUsed[i] = 0
		lettersChecked[i] = 0
	end
	
	for i in word
		lettersUsed[i] += 1
	end
	greenPass(input, i)
	if greenIndex == [1, 2, 3, 4, 5]
		global winStatus = 1
		break
	end

	wrongPass(input, i)
	print("\u001b8$(join(letters))\u001b[$(11 - i)F")

	global greenIndex = []
end



println("\u001b8\u001b[4E")

if winStatus == 1
	println("\u001b[32mYou Win!\u001b[39m")
else
	println("\u001b[31mYou Lose\nThe word was: $(join(word))\u001b[39m")
end
