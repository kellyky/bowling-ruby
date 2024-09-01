🦺 README under construction 🚧

## About

My approach to Exercism's [Bowling](https://exercism.org/tracks/ruby/exercises/bowling) exercise, written in Ruby (v. 3.3.0).

The Ruby code for the solution is my own; `bowling_test.rb` and `.exercism` - and some of the README below are from Exercism.

### Requirements and Objective

Write code to keep track of the score of a game of bowling:

- `roll(pins)` is called each time the player rolls a ball.
  The argument is the number of pins knocked down.
- `score` is called only at the very end of the game.
  It returns the total score for that game.


## Test
Test file bowling_test.rb	provided by Exercism. Test cases cover edge cases, including too many / few rolls, perfect game (all strikes), spare in the 10th frame, and more.

To test my code:
1. Clone this repo `git clone git@github.com:kellyky/bowling-ruby.git`
2. `cd` into this directory
3. Run the tests `ruby bowling_test.rb`


## Scoring Bowling
_Section from Exercism: https://exercism.org/tracks/ruby/exercises/bowling_

The game consists of 10 frames.
A frame is composed of one or two ball throws with 10 pins standing at frame initialization.
There are three cases for the tabulation of a frame.

- An open frame is where a score of less than 10 is recorded for the frame.
  In this case the score for the frame is the number of pins knocked down.

- A spare is where all ten pins are knocked down by the second throw.
  The total value of a spare is 10 plus the number of pins knocked down in their next throw.

- A strike is where all ten pins are knocked down by the first throw.
  The total value of a strike is 10 plus the number of pins knocked down in the next two throws.
  If a strike is immediately followed by a second strike, then the value of the first strike cannot be determined until the ball is thrown one more time.


<details>
<summary>Toggle for a three frame example</summary>

| Frame 1         | Frame 2       | Frame 3                |
| :-------------: |:-------------:| :---------------------:|
| X (strike)      | 5/ (spare)    | 9 0 (open frame)       |

Frame 1 is (10 + 5 + 5) = 20

Frame 2 is (5 + 5 + 9) = 19

Frame 3 is (9 + 0) = 9

This means the current running total is 48.

The tenth frame in the game is a special case.
If someone throws a spare or a strike then they get one or two fill balls respectively.
Fill balls exist to calculate the total of the 10th frame.
Scoring a strike or spare on the fill ball does not give the player more fill balls.
The total value of the 10th frame is the total number of pins knocked down.

For a tenth frame of X1/ (strike and a spare), the total value is 20.

For a tenth frame of XXX (three strikes), the total value is 30.
</details>

## Requirements of the Exercise
_Section from Exercism: https://exercism.org/tracks/ruby/exercises/bowling_

Write code to keep track of the score of a game of bowling.
It should support two operations:

- `roll(pins : int)` is called each time the player rolls a ball.
  The argument is the number of pins knocked down.
- `score() : int` is called only at the very end of the game.
  It returns the total score for that game.

## Source

### Created by

- @bernardoamc

### Contributed to by

- @budmc29
- @cadwallion
- @gchan
- @hilary
- @iHiD
- @Insti
- @jpotts244
- @kotp
- @kytrinyx
- @NeimadTL
- @tryantwit

### Based on

The Bowling Game Kata from UncleBob - https://web.archive.org/web/20221001111000/http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata
