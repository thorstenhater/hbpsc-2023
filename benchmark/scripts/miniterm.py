import sys
import unicodedata

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

lines = []

LINE_UP = '\033[1A'
LINE_CLEAR = '\x1b[2K'
SZ = 10

try:
    for line in sys.stdin:
        line = line.rstrip()
        line = remove_control_characters(line)
        if len(line) > 80:
            line = line[:78] + '..'
        line = line.ljust(80)
        lines.append(line)
        if len(lines) <= SZ:
            print(line)
        else:
            for _ in range(SZ):
                print(end=LINE_UP+LINE_CLEAR)
            for line in lines[-SZ:]:
                print(line)
    print()
except KeyboardInterrupt:
    print()
    print('^C')
