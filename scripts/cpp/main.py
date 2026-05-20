import json
from build_list import build_list

def main():
    list = []
    list = build_list('html/cpp', list)

    with open('../../data/test.json', 'w') as f:
        json.dump(list, f, indent = 2)

if __name__ == "__main__":
    main()

