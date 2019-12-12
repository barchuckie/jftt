def compute_prefix_function(pattern):
    pattern_length = len(pattern)
    pi = []
    pi.append(-1)
    k = -1
    for q in range(1, pattern_length):
        while k > -1 and pattern[k + 1] != pattern[q]:
            k = pi[k]
        if pattern[k + 1] == pattern[q]:
            k = k + 1
        pi.append(k)

    return pi


def kmp_matcher(text, pattern):
    text_length = len(text)
    pattern_length = len(pattern)
    pi = compute_prefix_function(pattern)
    q = -1

    for i in range(text_length):
        while q > -1 and pattern[q + 1] != text[i]:
            q = pi[q]
        if pattern[q + 1] == text[i]:
            q = q + 1
        if q + 1 == pattern_length:
            print("Pattern occurs with shift ", i - pattern_length + 1)
            q = pi[q]
