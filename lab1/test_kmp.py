import kmp

text = input("Text: ")
while 1:
    pattern = input("Pattern: ")
    kmp.kmp_matcher(text, pattern)
