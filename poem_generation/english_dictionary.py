import bz2
import glob

import requests
import string

# INFILE = "dictionary/words_alpha.txt"
OUTFILE = "../assets/dictionary/en.bzip2"


#
#
# def keep_word(word: str) -> True:
#     new_word = word.strip()
#     return len(set(new_word)) > 2
#
#
# if __name__ == '__main__':
#     with open(INFILE, "r") as f:
#         original_words = f.readlines()
#
#     words_to_drop = [_.strip() for _ in original_words if not keep_word(_)]

def keep_word(word: str):
    if " " in word:
        return False

    if "." in word:
        return False

    if "-" in word:
        return False

    if len(word) < 3:
        return False

    if word[0].isupper():
        return False

    if word.isupper():
        return False

    return True


def out_of_dict_words(dictionary):
    list_words = [_[:-4][6:] for _ in glob.glob("words/*")]
    out_of_dict = []
    for word in list_words:
        if word not in dictionary:
            out_of_dict.append(word)
    return out_of_dict


if __name__ == '__main__':
    all_words = []
    for letter in string.ascii_lowercase:
        print(f"Words starting with {letter}")
        words_raw = requests.get(
            f"https://raw.githubusercontent.com/wordset/wordset-dictionary/master/data/{letter}.json").json()
        all_words.extend(_ for _ in words_raw.keys() if keep_word(_))

    all_words.extend(out_of_dict_words(all_words))

    with bz2.open(OUTFILE, "wt") as compressed_output:
        # Write compressed data to file
        unused = compressed_output.write("\n".join(all_words))
