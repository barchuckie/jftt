import kmp
import automaton_matcher

alphabet = input("Alphabet: ")
text = input("Text: ")
while 1:
    pattern = input("Pattern: ")
    print("AUTOMATON:")
    tf = automaton_matcher.compute_transition_function(pattern, alphabet)
    if automaton_matcher.finite_automaton_matcher(text, tf, len(pattern)):
        break

    print("KMP:")
    kmp.kmp_matcher(text, pattern)
    print()
