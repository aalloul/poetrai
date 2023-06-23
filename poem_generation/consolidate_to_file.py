import json
import glob
from typing import List
from datetime import date, timedelta
import bz2
import random


def read_file(file_path: str) -> str:
    with open(file_path, "r") as f:
        content = "".join(f.readlines()[1:]).strip()

    return content


def content_to_parts(full_poem: str) -> List[str]:
    stanzas = [_ for _ in full_poem.split("\n\n") if _.strip()]

    if len(stanzas) < 4:
        raise Exception(f"Could not find enough stanzas in poem {full_poem}")
    else:
        return stanzas


def to_json_rep(split_content: List[str], today_word: str) -> dict:
    return {
        "todayWord": today_word,
        "part1": split_content[0],
        "part2": split_content[1],
        "part3": split_content[2],
        "part4": split_content[3],
    }


def extract_todays_word(file_name: str) -> str:
    return file_name.split("/")[-1].split(".")[0]


def generate_shuffled_date_list(from_date: date, n_dates: int):
    date_list = [from_date + timedelta(days=_) for _ in range(n_dates)]
    random.shuffle(date_list)
    return date_list


if __name__ == "__main__":
    file_list = glob.glob("words/*")

    start_date = date(2023, 6, 23)
    list_date_for_word = generate_shuffled_date_list(start_date, len(file_list))

    today_date = date.today()
    out = {}

    for idx, file in enumerate(file_list):
        print(f"working on file {file}")
        file_content = read_file(file)
        processed_content = content_to_parts(file_content)
        word_to_guess = extract_todays_word(file)

        date_for_word = list_date_for_word[idx].strftime("%Y%m%d")
        out[date_for_word] = to_json_rep(processed_content, word_to_guess)

    with open(f"output/run_{today_date}_words_{len(out)}.json", "w") as raw_output:
        json.dump(out, raw_output, indent=4)

    with bz2.open("../assets/poems/poems.bzip2", "wt") as compressed_output:
        # Write compressed data to file
        unused = compressed_output.write(json.dumps(out))
