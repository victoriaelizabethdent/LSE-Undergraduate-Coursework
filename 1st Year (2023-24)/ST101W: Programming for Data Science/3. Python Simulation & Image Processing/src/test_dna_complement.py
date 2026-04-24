from dna_complement import dna_complement

# testing for an empty string
assert dna_complement('') == '', "test failed for empty string, expected return value: ''" 

# testing single characters (smallest, valid input)
assert dna_complement("A") == "T", "failed on single character A, expected return value: 'T'"
assert dna_complement("T") == "A", "Failed on single character T, expected return value: 'A'"
assert dna_complement("C") == "G", "Failed on single character C, expected return value: 'G'"
assert dna_complement("G") == "C", "Failed on single character G, expected return value: 'C'"

# testing pairs of characters (second smallest, valid input)
assert dna_complement("AT") == "TA", "failed on pair AT, expected return value: 'TA'"
assert dna_complement("CG") == "GC", "failed on pair CG, expected return value: 'GC'"

# testing for duplicate/repeated letters
assert dna_complement('AAAA') == 'TTTT', "test failed for repeated letters, expected return value: 'TTTT'" 

# testing for all the 4 defined letters
assert dna_complement('ATGC') == 'TACG', "test failed for all for DNA letters, expected return value: 'TACG'" 