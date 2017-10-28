# foac
Four On a Couch game simulator

## Usage 
    ruby main.rb [-h|--help] [-c <player count>] [-a <arrangement>] [-1 <team 1 strategy>] [-2 <team 2 strategy>] [-b <number of times to run>] [-v]

## Writing Strategies
A strategy is a class with three functions, `initialize`, `think`, and `remember`.

Strategies must be named `Strategy<name>`, e.g. `Strategyrandom`.

`initialize` is passed the parent object, a Strategy instance. It has two attributes, `player`, and `memory`.
`memory` is an empty hash. Use it as you wish.
`player` is the parent Player object. Its attributes are `name`, `team`, `position`, and `pseudonym`.

`remember` is called every time someone calls a name. It is passed the real name of the called person, their team, the position they were called from, the name (pseudonym) that was called, and the real name of the caller.

`think` is called when it's the player's turn to call a name.

Check out some of the strategies in the 'strategies' folder for examples. Note that you can access all the global objects - $players, $positions, and $teams. Obviously you could cheat by changing them, or looking at $pseudonyms, but the point of this program is not *winning*, it's *science*.

## Writing Arrangements
An arrangement is a function that returns a Hash of players, with the player number as the key and their team as the value.
Arrangements must be named `arrangement<name>`, e.g. `arrangementalternating`.

Check out some of the arrangements in the 'arrangements' folder for examples.
