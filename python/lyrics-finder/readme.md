# Lyrics Finder

A program that returns the lyrics to the given song title.

## Usage
`$ lyrics_finder.py song_tile`

#### Example 0 : _*correctly spelled title*

`$ lyrics_finder.py the man who sold the world`

#### Output
```
Nirvana - The Man Who Sold The World

We passed upon the stair
... [lyrics continues]

Oh no, not me
We never lost control
You're face to face
With the man who sold the world

... [lyrics continues]
```

#### Example 1 : *I don't remember the actual song title, but it's something like...*

`$ lyrics_finder.py the woman who sailed the world`

#### Output
```
Nirvana - The Man Who Sold The World

We passed upon the stair
... [lyrics continues]

Oh no, not me
We never lost control
You're face to face
With the man who sold the world

... [lyrics continues]
```

## Tips

Use `lyrics_finder.py` with Unix's `less` command 👻

**in `$HOME/.bashrc`, I added**
```bash
    function ly() {
		python3.6 /path/to/lyrics_finder.py $@ | less
	}
```
### Usage

`$ ly song_tile`

