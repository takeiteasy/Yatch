# Yatch

An iOS Yatch dice game using SpriteKit. [Poker Dice](https://en.wikipedia.org/wiki/Yacht_(dice_game)), similar to Yatzee. Rules are based off [Clubhouse Games for Switch](https://www.nintendo.com/store/products/clubhouse-games-51-worldwide-classics-switch/). Designed for iPhone.

<p align="center">
    <img src="https://github.com/takeiteasy/Yatch/blob/master/screenshot.png?raw=true">
</p>


## How to play

### Basics

At the start of a round you roll 5 dice, after rolling you can choose to save dice (or discard previously saved dice) to make a hand. Each round consists of a maximum of 3 turns (not all turns need to be taken). If you haven't made a hand at the end of the 3 turns, you will have to pick whichever category (hand type) is best. The game ends when every category is filled! Note: once a category is chosen it can't be changed.

### Hands

- Aces: Sum of all 1-dice (e.g. 1-1-1-2-4 = 3 points)
- Duces: Sum of all 2-dice (e.g. 2-2-4-5-6 = 4 points)
- Threes: Sum of all 3-dice (e.g. 3-3-3-3-5 = 12 points)
- Fours: Sum of all 4-dice (e.g. 4-5-5-2-1 = 4 points)
- Fives: Sum of all 5-dice (e.g. 5-5-5-5-5 = 25 points)
- Sixes: Sum of all 6-dice (e.g. 6-6-6-2-1 = 18 points)
- Choice: Sum of all dice (e.g. 1-2-5-6-3 = 17 points)
- Four-of-a-kind: 4 of the same dice + extra die (e.g. 4-4-4-4-5 = 21 points, 1-2-3-4-5 = 0 points)
- Full house: 3 of a kind + pair: (e.g. 3-3-3-2-2 = 13 points, 4-4-4-5-2 = 0 points)
- Small straight: 4-dice run (1-2-3-4-1 = 15 points)
- Large straight: 5-dice run (2-3-4-5-6 = 30 points)
- Yatch: All dice same face (e.g. 1-1-1-1-1 = 50 points)
- Bonus: Non-selectable category, achieved by gaining 63 points total in the numbered categories

### Tips

- If you are already holding a hand (e.g. 1-1-1-1), keep rolling, you may get something better and you risk nothing!
- Not all categories are made equal: The maximum points for Aces is 5 for example. Maybe if you don't get the hand you wanted you could forfeit the weaker categories.
- One easy way of thinking about the bonus is that 3-of-a-kind in each of the numbered categories is 63. You don't ***have*** to get 3-of-kind in each, but it's a good way of keeping track.
- If you're doing poorly, just quit! It's a single player game, who cares!

## Assets

 - Dice sprites - [kicked-in-teeth](https://kicked-in-teeth.itch.io/dice-roll) (CC-by-sa)
 - Notepad, Pencil, back icons - [vectorpixelstar](https://vectorpixelstar.itch.io/1-bit-icons-part-2) (CC BY-ND 4.0)
 - Sound effects - [kenney.nl](https://www.kenney.nl/assets/interface-sounds) (CC0 1.0 Universal)
 - Music - [gooseninja](https://gooseninja.itch.io/minimalistc-loops) (CC?)
 - Cup sprite and dice sound effects done myself
 
## TODO

- [X] ~~Bonus score (63 points in 1-6 categories)~~
- [X] ~~Menu scene~~
- [X] ~~Highscore tracking~~
- [X] ~~Restart game button~~
- [X] ~~More sound effects + music~~
- [ ] Toggle music/sfx buttons
- [ ] Volume sliders for music/sfx
- [X] ~~App icon~~
- [X] ~~How to play/rules section~~

## License
```
???Commons Clause??? License Condition v1.0

The Software is provided to you by the Licensor under the License, as defined
below, subject to the following condition.

Without limiting other conditions in the License, the grant of rights under the
License will not include, and the License does not grant to you, the right to
Sell the Software.

For purposes of the foregoing, ???Sell??? means practicing any or all of the rights
granted to you under the License to provide to third parties, for a fee or
other consideration (including without limitation fees for hosting or
consulting/ support services related to the Software), a product or service
whose value derives, entirely or substantially, from the functionality of the
Software. Any license notice or attribution required by the License must also
include this Commons Clause License Condition notice.

Software: Yatch

License: The MIT License (MIT)

Licensor: George Watson

The MIT License (MIT)

Copyright (c) 2022 George Watson

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
