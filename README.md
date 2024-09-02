## About

My approach to Exercism's [Bowling](https://exercism.org/tracks/ruby/exercises/bowling) exercise, written in Ruby (v. 3.3.0).

Requirements from Exercism:
> Write code to keep track of the score of a game of bowling.
> It should support two operations:
> - `roll(pins)` is called each time the player rolls a ball. The argument `pins` is the number of pins knocked down in a single roll.
> - `score` is called only at the very end of the game. It returns the total score for that game.
  

See .exercism/config.json for author and contributors to creating this exercise. Also, the test file is from Exercism - the solution code is my own, a number of the iterations are in response to mentor code review in Exercism (Thanks Vic!).

### Requirements and Objective

Write code to keep track of the score of a game of bowling:

- `roll(pins)` is called each time the player rolls a ball.
  The argument is the number of pins knocked down.
- `score` is called only at the very end of the game.
  It returns the total score for that game.


## Test
These steps assume you have Ruby installed. If you do not, see [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/).

Test file bowling_test.rb	provided by Exercism. Test cases cover edge cases, including too many / few rolls, perfect game (all strikes), spare in the 10th frame, and more.

To test my code:
1. Clone this repo `git clone git@github.com:kellyky/bowling-ruby.git`
2. `cd` into this directory
3. Install minitest `gem install minitest`
4. Run the tests `ruby bowling_test.rb`


## Scoring Bowling

A game of bowling has 10 frames. Each frame has at most **two** rolls*, and a total of 10 pins to knock down. 


| Frame Type         | Pins Down in Frame      | After __ Rolls | Frame Score |
| :-------------: |:-------------:| :-------------:| :-------------: |
| Strike     | 10 | 1 | Pins down in this frame (10) + Pins down in the next **2** rolls |
| Spare | 10  | 2 | Pins down in this frame (10) + Pins down in the next **1** roll |
| Open | less than 10 | 2 | Pins down in this frame |

*Frame 10 is an exception and _may_ be eligible for a **third** roll--if the player's first 1-2 rolls are a strike or spare. Then the third roll is granted to score the frame.

The score of the 1**0th frame** is the **sum of all 2 or 3 rolls**.

See Exercism for a 3-frame example and a more detailed explanation: Exercism: https://exercism.org/tracks/ruby/exercises/bowling


