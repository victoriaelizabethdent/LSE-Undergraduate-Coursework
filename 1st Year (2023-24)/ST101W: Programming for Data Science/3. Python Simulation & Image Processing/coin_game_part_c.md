# Q2c Coin Game (35 marks)

---

## Background

In this part, we will create "smart" players that know the "winning position".

---

## Description

1. (25 marks) Write a class definition for the class `SmartPlayer` in `src/player.py`. Its instances represent "smart" players who know the winning position described in Q2b. This class should be very similar to `Player`, in the sense that:

   - It has the method `notify_outcome()` for the game to notify the player about the outcome
   - It has the method `get_winning_percentage()` which is a method to return the winning percentage of the player for the last n games (all if n is not provided)
   - It has the method `play()`

   However, it is different from `Player`:

   - The behaviour of `play()` is different as it has a different strategy in selecting the number of coins:
     - If it is in a winning position, select the right number of coins to stay in a winning position
     - If not, select randomly among all possible numbers of coins (i.e. behave like "Player")
   - It may have some other internal data attributes/methods for figuring out whether it is in a winning position, and/or the right number of coins to select

2. (10 marks) In `src/coin_game.ipynb`, do the following:

   1. `SmartPlayer` vs `Player`

   - Create 1 instance of `SmartPlayer` (should now be defined in `src/player.py`)
   - Create an instance of `CoinGame` (defined in `src/coin_game.py`) by providing one of the players created in part a (`Player`), and the player created above (`SmartPlayer`), and use it to mimic the players playing the game for 1000 rounds
   - Print out the winning percentage of the players of the last 1000 rounds

   2. `SmartPlayer` vs `SmartPlayer`

   - Create one more instance of `SmartPlayer`
   - Create an instance of `CoinGame` by providing the first `SmartPlayer` created in (2.1), and the second `SmartPlayer` created above (2.2), and use it to mimic the players playing the game for 1000 rounds
   - Print out the winning percentage of the players of the last 1000 rounds

   - Please ensure the printouts are shown in the notebook
   - Answer the following question in some markdown cells: Do you think the `SmartPlayer` works by considering the winning percentage?

---

## Note

- You can use any functionalities from the `random` module from the Python Standard Library, and feel free to use the official documentation to find out the appropriate functions to use, and how to use them
- Feel free to have additional "helper methods" and/or additional data structures defined in the class definition (_if appropriate_)
- You do not necessarily need to use the functions from Q2b, but you can if you want to
