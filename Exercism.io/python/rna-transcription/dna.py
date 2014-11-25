
import string

def to_rna(dna):
    translation = string.maketrans("CGTA","GCAU")
    return dna.translate(translation)

