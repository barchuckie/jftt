def finite_automaton_matcher(text, transition_function, pattern_length):
    q = 0
    i = 1

    for sign in text:
        if not sign in transition_function[q]:
            print("Letter", sign, "is not in alphabet")
            return 1;
        q = transition_function[q][sign]
        if q == pattern_length:
            print("Pattern occurs with shift ", i - pattern_length)
        i += 1

    return 0


def compute_transition_function(pattern, alphabet):
    m = len(pattern)
    transition_function = []

    for q in range(m + 1):
        transition_function.append({})
        for char in alphabet:
            k = min(m, q + 1)

            while (pattern[:q] + char)[-k:] != pattern[:k] and k > 0:
                k -= 1

            transition_function[q][char] = k

    return transition_function
