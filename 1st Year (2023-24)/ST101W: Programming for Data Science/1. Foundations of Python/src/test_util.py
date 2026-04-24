import util

# ----- TESTING count_items_per_key() ----- #

test_cases_1 = [
    ({}, {}), # empty dictionary
    ({'a': []}, {'a': 0}), # empty value list 
    ({'a': [1],}, {'a': 1}), # smallest non-empty list
    ({'a': [1, 2, 3], 'b': [None]}, {'a': 3, 'b': 1}), # the example from q1.md
    ({'a': [1, [2,3], "four", (5,)]}, {'a': 4}), # different data types, and an embedded list within a list
    ] 

for dictionary, expected_output in test_cases_1:
    actual_output = util.count_items_per_key(dictionary)
    assert actual_output == expected_output, \
    f"Expected \"{expected_output}\" but returned \"{actual_output}\", argument: {dictionary}."

# ----- TESTING get_occurences_per_value() ----- #

test_cases_2 = [
    ({}, {}), # empty dictionary
    ({'a': ''}, {'': 1}), # smallest, immutable empty string
    ({'a': 1, 'b': ('1', '2'), 'c': 1}, {1: 2, ('1', '2'): 1} ), # the example from q1.md
    ({i: 1 for i in range(100)}, {1: 100}), # large dictionary with value '1'
    ({'a': 1}, {1: 1}), # small dictionary with value '1'
    ]

for dictionary, expected_output in test_cases_2:
    actual_output = util.get_occurences_per_value(dictionary)
    assert actual_output == expected_output, \
    f"Expected \"{expected_output}\" but returned \"{actual_output}\", argument: {dictionary}."

# ----- TESTING filter_with_values_gt() ----- #

test_cases_3 = [
    (({},0), {}), # empty dictionary, smallest non-negative integer (0)
    (({'a': 1}, 0), {'a': 1}), # smallest, non-empty dictionary with output
    (({'a': 3, 'b': 2, 'c': 1}, 2), {'a': 3}), # the example from q1.md
    (({'a': 2, (1,2,): 3, 0.3: 7}, 3), {0.3: 7}) # different data types, a boundary case (greater than 3, not >= 3)
    ]

for (dictionary, num), expected_output in test_cases_3:
    actual_output = util.filter_with_values_gt(dictionary, num)
    assert actual_output == expected_output, \
    f"Expected \"{expected_output}\" but returned \"{actual_output}\", argument: {dictionary}."

