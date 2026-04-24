def is_winning_position(position):
    '''
    DESCRIPTION:
        this function determines whether a given position is a winning position.
    ----------
    PARAMETERS: 
        position: int, greater than 0, the number of remaining coins
    RETURN:
        bool, True if the position is a winning one, False if it is not.
    '''    
    status = [False] * (position + 1) # 'position + 1' to make indexing easier

    for p in [1, 3, 6]:
        if p <= position:
            status[p] = True
    
    # determine their status based on previous positions
    for p in range(2, position + 1):
        if status[p]:
            continue
        status[p] = not status[p-1] or (p >= 3 and not status[p-3]) or (p >= 6 and not status[p-6])
    
    return status[position]

def is_winning_position_recursion(position, memo={}):
    '''
    DESCRIPTION:
        this function determines whether a given position is a winning position via a recursive approach.
    ----------
    PARAMETERS: 
        position: int, greater than 0, the number of remaining coins
        memo: dictionary, stores previously computed results
    RETURN:
        bool, True if the position is a winning one, False if it is not.
    '''
    # return if the position is already known
    if position in memo:
        return memo[position]
    if position in [0]:
        memo[position] = False
        return False
    if position in [1, 3, 6]:
        memo[position] = True
        return True

    losing_positions_for_opponent = [position - move for move in [1, 3, 6] if position - move >= 0]
    is_winning = any(not is_winning_position_recursion(pos, memo) for pos in losing_positions_for_opponent)
    memo[position] = is_winning

    return is_winning

# ensuring the function is quick enough when the argument is ~100:
print(is_winning_position_recursion(100))
    