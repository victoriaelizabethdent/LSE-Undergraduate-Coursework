# Q2a Coin Game (15 Marks)

---

## Background Information

In this question, we consider a simple coin game. The rules of the game are as follows:

- At the start, there are 100 coins. A player is chosen randomly to start the game
- For each turn, each player must take 1, 3 or 6 coins
- The player who takes the last coin wins the game and the game will finish

Here is an example of such a game:

```
player 1 selected 1 coins(s) from 100 coins(s), 99 coins(s) left.
player 2 selected 6 coins(s) from 99 coins(s), 93 coins(s) left.
player 1 selected 3 coins(s) from 93 coins(s), 90 coins(s) left.
player 2 selected 1 coins(s) from 90 coins(s), 89 coins(s) left.
...
player 1 selected 6 coins(s) from 10 coins(s), 4 coins(s) left.
player 2 selected 1 coins(s) from 4 coins(s), 3 coins(s) left.
player 1 selected 3 coins(s) from 3 coins(s) - player 1 won the game!
```

Note the printouts are for illustrative purposes only. For the implementation of the game (which is provided to you as `CoinGame` in `src/coin_game.py`), no intermediate or final results are printed out.

---

## Instructions

1. Write the class definition for the class `Player` in `src/player.py` for which its instances represent "naive" players in the game described above. How an instance of `Player` chooses the number of coins to pick is based on how many coins are currently available, and the strategy is as follows:

   - 7-100 coins: choose randomly between 1, 3 and 6 (with equal probability)
   - 6 coins: choose 6 coins (and win the game)
   - 4-5 coins: choose randomly between 1 and 3 (with equal probability)
   - 3 coins: choose 3 coins (and win the game)
   - 1-2 coins: there is no choice but to select 1 coin

   The class should have the following _instance_ methods:

   - `play()` which is a method being called when it is the player's turn to play

     - The method takes one argument (apart from `self`) which represents the number of coins left in the game (`int` in the range of 1 to 100)
     - It returns the number of coins the player takes (`int`: `1`, `3` or `6`) based on the strategy above
     - Example:
       ```
       >>> player_1 = Player()
       >>> player_1.play(10)
       6
       >>> player_1.play(4)
       3
       >>> player_1.play(1)
       1
       ```

   - `notify_outcome()` which is a method being called when the game is over to notify the player if s/he has won the game

     - The method takes one argument (apart from `self`) which is a `bool`. `True` means the player has won the game and `False` means the player has lost the game. The player should record all these `bool`s in a `list` for future use
     - It has no return value
     - Example:
       ```
       >>> player_1.notify_outcome(True)
       ```

   - `get_winning_percentage()` which is a method to return the winning percentage of the player for the last n games
     - The method takes one argument (apart from `self`) which represents the number of last n games used to calculate the winning percentage. If the argument is not given, then calculate the winning percentage based on all rounds s/he has played
     - It returns the winning percentage (`float`, in the range of [0,1])
     - Example:
       ```
       >>> player_1 = Player()
       >>> player_1.notify_outcome(True)
       >>> player_1.notify_outcome(False)
       >>> player_1.notify_outcome(True)
       >>> player_1.notify_outcome(True)
       >>> player_1.get_winning_percentage(2)
       1.0
       >>> player_1.get_winning_percentage()
       0.75
       ```

2. In `src/coin_game.ipynb`, do the following:
   - Create 2 instances of `Player` (should now be defined in `src/player.py`)
   - Create an instance of `CoinGame` (defined in `src/coin_game.py`) by providing the 2 players created, and use it to mimic 2 players playing the game for 10000 rounds
   - Print out the winning percentages of the players for all the rounds they have played
     - Please ensure the printouts are shown in the notebook
   - Answer the following question in some markdown cells: Are the winning percentages sensible?

---

## Note

- You can use any functionalities from the `random` module from the Python Standard Library, and feel free to use the official documentation to find out the appropriate functions to use, and how to use them
- Feel free to have additional "helper methods" and/or additional data structures defined in the class definition (_if appropriate_)
