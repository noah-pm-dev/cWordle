#! /usr/bin/env -S julia --handle-signals=no

using Printf, Dates, Pkg

try
	using HTTP
catch e
	Pkg.add("HTTP")
	using HTTP
end


include("getWord.jl")

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
				try
					letters[findfirst(isequal(input[i]), letters)] = "\u001b[42m" * letters[findfirst(isequal(input[i]), letters)] * "\u001b[49m"
				catch e
					continue
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
				#sleep(1)
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
				#sleep(1)
			end
		else
			@printf("\u001b[1C")
		end
	end
end


word = [char for char in getWord()]
lettersUsed = Dict{Char, Any}()
lettersChecked = Dict{Char, Any}()
greenIndex = []
greenList = Dict{Char, Bool}()
orangeList = Dict{Char, Bool}()
greyList = Dict{Char, Bool}()
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', "\n", 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', "\n", 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
winStatus = 0
validStatus = 0
validList = String(read("$wd/validList.dat")) |> Meta.parse |> eval

for i in letters
	if i != "\n"
		greenList[i] = false
		orangeList[i] = false
		greyList[i] = false
	end
end


print("\n\n\n\n\n\n\n\n\n$(join(letters))\u001b[1A\u001b[1F\u001b7\u001b[8A\u001b[1F")



for i in 1:6
	#global lettersUsed = Dict{Char, Any}()
	#global lettersChecked = Dict{Char, Any}()
	@label redo_input
	print("a")
	input = [char for char in readline()]
	#inputCharOne = input[1]
	for word in validList
		if word == join(input)
			print("e")
			global validStatus = 1
		end
	end
	if validStatus != 1 || length(input) < 5 || length(input) > 5
		print("e")
		print("\u001b[1F\u001b[5;31m$(join(input))")
		sleep(1.5)
		print("\r        \u001b[0m\u001b[10D")
		@goto redo_input
	end

	

	
	#sleep(1)
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

	#println(greenIndex)
	#sleep(1)
	wrongPass(input, i)
	print("\u001b8$(join(letters))\u001b[$(11 - i)F")
	#println()
	global greenIndex = []
end


#println(letters)


println("\u001b8\u001b[4E")

if winStatus == 1
	println("\u001b[32mYou Win!\u001b[39m")
else
	println("\u001b[31mYou Lose\nThe word was: $(join(word))\u001b[39m")
end