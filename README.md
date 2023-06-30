# cWordle
cWordle is a command line clone of Wordle written in Julia. 

## Running
To run the program, first navigate into the `src` folder, then either run the program with `julia main.jl`, or alternatively, make the program executable (e.g. `chmod +x`) and run it with `./main.jl`.

The program must be run from within the `src` folder to be able to access the data files correctly.

## How it works
### Output
This is an incredibly simple program, as it makes use of [ANSI escape codes](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797) to control the cursor and text output. As such, it is not very stable and there could be bugs that cause text to be printed in the wrong spot, text to be randomly deleted etc.

This is not a safe method and shouldn't be used in real programs, this project is simply an experiment.

### Word lists
There are two word lists. `validList` is a list of words that are allowed as guesses. None of these words can ever be the answer to a wordle puzzle. The second list, `wordList`, is the list of possible answers, which the game chooses randomly each time it is run.

The word lists and this logic are taken directly from the game Wordle, I did not create this.

