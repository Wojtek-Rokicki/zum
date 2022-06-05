import os
import json
import csv
from tqdm import tqdm

from email_parser import initParser

def load_ngrams_dictionary():
    with open('ngrams_dict/uni_grams_dict_all_en.json', "r", encoding="utf-8") as f:
            dictionary_content = f.read()
            dictionary = json.loads(dictionary_content)
    return dictionary

def limit_ngram_representation(ngrams_dictionary, min_freq, max_freq):
    ngrams_dictionary_limited = {}
    for k,v in ngrams_dictionary.items():
        if v >=  min_freq and v <= max_freq:
            ngrams_dictionary_limited.update({k:v})
    return ngrams_dictionary_limited

def save_ngrams_dictionary(ngrams_dictionary, min_freq, max_freq):
    dirname = "ngrams_dict_limited"
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    filename = f"limited_ngram_dict_{min_freq}_{max_freq}"
    with open(os.path.join(dirname, filename), "w", encoding="utf-8") as f:
        f.write(json.dumps(ngrams_dictionary))

def read_configuration():
    cwd = os.getcwd()
    print(cwd)
    with open("email_parser/parser_conf.json", "r", encoding="utf-8") as f:
        config = json.loads(f.read())
    return config

def create_freq_vector_repr(ngrams_dictionary_limited, min, max):
    config = read_configuration()
    ep, class_value, bodys = initParser(config)
    all_ngrams_freq_vectors = []
    for i, b in tqdm(enumerate(bodys)):
        try:
            lemm = ep.preprocess(b)
            ngrams_freq_vector = ep.buildFreqVec(lemm, ngrams_dictionary_limited)
            ngrams_freq_vector.append(class_value)
            all_ngrams_freq_vectors.append(ngrams_freq_vector)
        except Exception as e:
            print(f"[{i}]: {e}") 
            continue
    
    filename = config["class"] + f"_freq_vec_en_{min}_{max}.csv"
    save_ngrams_freq_vectors(ngrams_dictionary_limited, filename)

def save_ngrams_freq_vectors(all_ngrams_freq_vectors, filename):
    dirname = "ngrams_vec_limited"
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    with open(os.path.join(dirname, filename), "w", encoding="utf-8") as f:
       csvwriter = csv.writer(f)
       csvwriter.writerows(all_ngrams_freq_vectors)


if __name__ == '__main__':
    ngrams_dictionary = load_ngrams_dictionary()
    ngrams_max_freq = max(ngrams_dictionary.values())

    # For range(a, b) it goes from {a, a+1, ..., b-1}
    for min in [15, 49, 122]:
        for max in [ngrams_max_freq, ngrams_max_freq-1500, ngrams_max_freq-3000]:
            ngrams_dictionary_limited = limit_ngram_representation(ngrams_dictionary, min, max)
            print(f'Dictionary min: {min}, max: {max} of length: {len(ngrams_dictionary_limited)}')
            save_ngrams_dictionary(ngrams_dictionary_limited, min, max)
            create_freq_vector_repr(ngrams_dictionary_limited, min, max)
