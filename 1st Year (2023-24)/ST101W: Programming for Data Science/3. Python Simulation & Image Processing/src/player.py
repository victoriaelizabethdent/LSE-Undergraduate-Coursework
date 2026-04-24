'''
this file contains class definitions for Player and SmartPlayer (a child class of Player)
'''

import random
from winning_position import is_winning_position

class Player:
    '''
    this class initialises the object, Player, which represents 'naive' players in a game.
    '''
    def __init__(self):
        self.game_outcomes = [] # a list storing all game outcomes
    
    def play(self, coins_left):
        '''
        DESCRIPTION:
            this method returns the number of coins the player takes when it is their turn.
        ----------
        PARAMETERS:
            coins_left: int, represents the number of coins left in the game in range 1-100.
        RETURNS:
            the number of coins the player takes.
        '''
        if coins_left >= 7:
            return random.choice([1, 3, 6])
        elif coins_left == 6:
            return 6
        elif 4 <= coins_left <= 5:
            return random.choice([1, 3])
        elif coins_left == 3:
            return 3
        else:
            return 1
    
    def notify_outcome(self, win):
        '''
        DESCRIPTION:
            this method notifies the player if they have won the game.
            the (bool) outcome of the game is stored in a list for future use.
        ----------
        PARAMETERS:
            win: bool, True if the player has won and False if they have lost.
        RETURNS:
            N/A.
        '''
        self.game_outcomes.append(win)
    
    def get_winning_percentage(self, last_n_games=None):
        '''
        DESCRIPTION:
            this method calculates the winning percentage of the last n games.
        ----------
        PARAMETERS:
            last_n_games: int, the last amount of rounds to base the winning percentage on. 
                               if the parameter is not given, it is based on all the player's rounds.
        RETURNS:
            winning_percentage: float, in the range of [0,1], the winning percentage of the last n games.
        '''        
        if last_n_games is None:
            chosen_outcomes = self.game_outcomes
            total_games = len(self.game_outcomes)
        else:
            total_games = min(last_n_games, len(self.game_outcomes))
            chosen_outcomes = self.game_outcomes[-total_games:]
        
        try:
            winning_games = sum(chosen_outcomes)
            winning_percentage = winning_games / total_games
        except ZeroDivisionError:
             winning_percentage = 0.0
        
        return winning_percentage

class SmartPlayer(Player):
    '''
    this class initialises the object, SmartPlayer, who know the winning positions in the game.
    '''
    def __init__(self):
        super().__init__() 
        self.memo = {}

    def play(self, coins_left):
        '''
        DESCRIPTION:
            this method returns the number of coins the player takes when it is their turn.
        ----------
        PARAMETERS:
            coins_left: int, represents the number of coins left in the game in range 1-100.
        RETURNS:
            the number of coins the player takes.
        '''
        possible_moves = [1, 3, 6]
        for move in possible_moves:
            if coins_left - move >= 0 and not (is_winning_position(coins_left - move)):
                return move
        # if not in a winning position, behave like "Player"
        return super().play(coins_left)