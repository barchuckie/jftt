import automaton_matcher

alphabet = input("Alphabet: ")
text = input("Text: ")
while 1:
    pattern = input("Pattern: ")
    tf = automaton_matcher.compute_transition_function(pattern, alphabet)
    if automaton_matcher.finite_automaton_matcher(text, tf, len(pattern)):
        break
