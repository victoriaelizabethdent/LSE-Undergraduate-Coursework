'''
util.py: this MODULE contains functions that return information on given dictionaries.
'''

# ----- count_items_per_key ----- #

def count_items_per_key(dictionary):
    '''
    DESCRIPTION
    ----------
    PARAMETERS:
        dictionary: a dictionary of key-value pairs, where each value is a list
    RETURNS:
        value_to_length: a dictionary of key-value pairs, where the key is the same as in 'dictionary', and each value is the length of the value list from 'dictionary'
    '''
    value_to_length  = {}

    for key, value in dictionary.items():
        value_to_length[key] = len(value)
    
    return value_to_length

# ----- get_occurences_per_value ----- #

def get_occurences_per_value(dictionary):
    '''
    DESCRIPTION
    ----------
    PARAMETERS:
        dictionary: a dictionary of key-value pairs, where each value is immutable
    RETURNS:
        occurences_of_values: a dictionary of key-value pairs, where the keys are a unique value from 'dictionary', and each value is how often it occurs
    '''
    occurences_of_values = {}

    for value in dictionary.values():
        if value in occurences_of_values:
            occurences_of_values[value] += 1
        else:
            occurences_of_values[value] = 1

    return occurences_of_values

# ----- filter_with_values_gt ----- #

def filter_with_values_gt(dictionary, num):
    '''
    DESCRIPTION
    ----------
    PARAMETERS:
        dictionary: a dictionary of key-value pairs, where each value is a non-negative integer
        num: a non-negative integer (a 'threshold')
    RETURN:
        greater_than_threshold: a dictionary which holds key-value pairs if the value is greater than 'num' (the threshold)
    '''
    greater_than_threshold = {}

    for key, value in dictionary.items():
        if value > num:
            greater_than_threshold[key] = value

    return greater_than_threshold

filter_with_values_gt({}, 0)
