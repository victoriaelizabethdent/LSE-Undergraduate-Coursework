from functools import reduce

def dna_complement(dna_base):
    '''
    DESCRIPTION
        this function completes a given DNA strand composed of 'A','T','C','G' by providing the complement of half of the strand.
    ----------
    PARAMETERS:
        dna_str: str, represents half of a DNA strand composed of combinations of the letters 'A', 'T', 'C', 'G'
    RETURNS:
        complement_str: str, represents the complementary half of the DNA strand with the combinations of the complementary letters
    '''
    dna_pairs = {'A' : 'T', 'T' : 'A', 'G' : 'C', 'C' : 'G'}

    complement_list = map(lambda base: dna_pairs.get(base), dna_base)
    complement_str = reduce(lambda complement, base: complement + base, complement_list, '')

    return complement_str