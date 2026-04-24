# Q2b Coin Game (35 Marks)

---

## Background

For a coin game, a winning position is a position where the next move can force a win through strategic play. For the coin game we considered in Q2a, 1, 3, and 6 the winning positions because the player can take the rest of the coins and win the game. On the other hand, 2 and 4 are losing positions as no matter how many coins the player chooses (out of the possible moves), it will leave its opponent in a winning position. For example, with 4 coins, the only possible moves are 1 and 3. However, taking 1 coin will leave opponents with 3 coins, and taking 3 coins will leave opponents with 1 coin. Both 1 and 3 are winning positions. How about 5? 5 is a winning position as by taking a right number of coins (e.g. 1 coin), the player leaves its opponent in a losing position (4 coins).

---

## Description

1. In [`src/winning_position.py`](src/winning_position.py), write the function definition `is_winning_position()`, which takes a positive integer and returns a boolean value representing whether a given position is a winning position.

The function must not be implemented in a recursive approach. There must not be any function calling itself (directly and/or indirectly).

Hint: you may find some patterns in the sequence of the winning positions

2. In [`src/winning_position.py`](src/winning_position.py), write the function definition `is_winning_position_recursion()`, which also takes a positive integer and returns a boolean value representing whether a given position is a winning position.

Unlike (1), The function must be implemented via a recursive approach. All forms of loops (for or while loops, including things like tuple or list comprehension) must not be used, and the implementation should mimic the following thought process:

It is a winning position if out of all position moves, there is at least one move that causes the opponent to be in a losing position (i.e. not a winning position).

Please ensure the function is quick enough when the argument is ~100.
