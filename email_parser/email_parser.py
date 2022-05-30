import email
import json
import traceback
from  tqdm import tqdm
from email import policy
from os import listdir
from os.path import isfile, join
import traceback
import spacy
import numpy as np 
import csv
import os
from spam_preprocessing import EmmailPreprocessing
#from gensim.models import Word2Vec
#from gensim.models import KeyedVectors
#from gensim.scripts.glove2word2vec import glove2word2vec
#from gensim.test.utils import datapath, get_tmpfile
from freq_builder import FreqBuilder


class EmailParser(EmmailPreprocessing):
    def __init__(self, source_word_vec_file = "", use_spacy = True) -> None:
        super().__init__()
        #self.w2v_model = KeyedVectors.load_word2vec_format(
            # 'data/GoogleGoogleNews-vectors-negative300.bin', binary=True)
        self.use_spacy = use_spacy
        if self.use_spacy:
            self.w2v_model = spacy.load('en_core_web_md')
        else:
            #self.w2v_model = KeyedVectors.load_word2vec_format(source_word_vec_file, binary=False)
            pass


    def getEmailBody(self, filename):
        with open(filename, "r", encoding="utf-8", errors='ignore') as f:
            m_str =  f.read()
            msg = email.message_from_string(m_str, policy=policy.default)
            try:
                body = msg.get_body(('plain',))
                if body:
                    body = body.get_content()
                else:
                    return False
            except Exception as e:
                print(e)
                print(filename)
                return False

        return body


    def dumpToFile(self, filename, text):
        with open(filename, "w", encoding="utf-8") as f:
            f.write(text)

    def readEmailsBody(self, dir_path, max_files:int = -1):
        bodys = []
        emails_files = [f for f in listdir(dir_path) if isfile(join(dir_path, f))]
        for i, ef in tqdm(enumerate(emails_files)):
            tmp = self.getEmailBody(dir_path + ef)
            if tmp:
                bodys.append(tmp)
                #dumpToFile(f"{out_dir + ef}_body", tmp)
            if i == max_files: break

        return bodys

    def buildFreqVec(self, lemms, ngram_dict):
        vec = []
        np_lemms = np.array(lemms)
        for ngram in ngram_dict.keys():
            c = np.count_nonzero(np_lemms == ngram)
            vec.append(c)
            #vec.append(self.countNgram(lemms, ngram))
        return vec

    def countNgram(self, lemms, ngram):
        cnt = 0
        for l in lemms:
            if l == ngram: cnt+=1
        
        return cnt

    
    def buildEmmbedding(self, body):
        if self.use_spacy:
            return self.buildEmmbedding_spacy(body)
        else:
            return self.buildEmmbedding_w2v(body)


    def buildEmmbedding_w2v(self, body):
        #vec = Word2Vec(body, min_count=1)
        self.w2v_model
        vec = [self.w2v_model[x] for x in body]
        return vec

    def buildEmmbedding_spacy(self, body):
        vec = []
        for token in body:
            vec.append(self.w2v_model(token).vector)
        vec_mean  = np.nanmean(vec, axis=0)
        return vec_mean


    def generate_N_grams(self, words, ngram=2):
        temp=zip(*[words[i:] for i in range(0,ngram)])
        res=[' '.join(ngram) for ngram in temp]
        return res


    #@classmethod
    #def glove2w2v(cls, source_file, out_file):
    #    glove_file = datapath(source_file)
    #    tmp_file = get_tmpfile(out_file)
    #    _ = glove2word2vec(glove_file, tmp_file)
        


def initParser(config):
    ep = EmailParser(config["w2v_model"], use_spacy=True)
    class_value = config["class"]
    if class_value == "spam":
        bodys = ep.readEmailsBody(config["spam_dir"])
    elif class_value == "ham":
        bodys = ep.readEmailsBody(config["ham_dir"])
    else:
        raise Exception("invalid class value in config. Allowed: [ham|spam]")
    print(len(bodys))
    
    return ep, class_value, bodys


cwd = os.getcwd()
print(cwd)
with open("email_parser\parser_conf.json", "r", encoding="utf-8") as f:
    config = json.loads(f.read())


#uncoment following when run for the first time
EmmailPreprocessing.downloadNLTKPackages()

#mode = "BUILD_EMMBEDINGS" 
#mode = "BUILD_NGRAMS" 
#mode = "BUILD_FREQ_VEC" 
#mode = "ELSE"
mode = config["mode"]

if mode == "BUILD_EMMBEDINGS":
    ep, class_value, bodys = initParser(config)
    emmbedings = []
    for i, b in tqdm(enumerate(bodys)):
        try:
            lemm = ep.preprocess(b)
            e = ep.buildEmmbedding(lemm)
            if len(e):
                e = np.append(e, [class_value], axis=0)
                emmbedings.append(e)
        except Exception as e:
            print(f"[{i}]: {e}") 
            continue

    with open('easy_ham_embbedings_300.csv', 'a') as f:
        csvwriter = csv.writer(f)
        csvwriter.writerows(emmbedings)


#build freq vectors
elif mode == "BUILD_NGRAMS":
    ep, class_value, bodys = initParser(config)
    fb = FreqBuilder(config["ngram_dict_outfile"])
    for i, b in tqdm(enumerate(bodys)):
        try:
            lemm = ep.preprocess(b, match_nltk_corpus=True)
            e = ep.generate_N_grams(lemm, ngram=2)
            fb.fitToDict(e)
        except Exception as e:
            print(f"[{i}]: {e}") 
            continue
        if i%30 == 0:
            fb.saveDict()
            
    fb.saveDict()
    fb.dumpSortedDict(file_out = f"{config['ngram_dict_outfile']}_sorted.txt")


elif mode == "BUILD_FREQ_VEC_UNI":
    ep, class_value, bodys = initParser(config)
    fb_uni = FreqBuilder("uni_grams_dict_all_en.json")
    uni_dict = fb_uni.getDict()
    #fb.dumpSortedDict(file_out = "bi_grams_sorted.txt")
    #fb.dumpSortedDict(file_out = "uni_grams_sorted.txt")
    uni_vectors = []
    for i, b in tqdm(enumerate(bodys)):
        try:
            lemm = ep.preprocess(b)
            vec_uni = ep.buildFreqVec(lemm, uni_dict)
            vec_uni.append(class_value)
            uni_vectors.append(vec_uni)
        except Exception as e:
            print(f"[{i}]: {e}") 
            continue

    with open('ham_freq_vec_uni_en.csv', 'a') as f:
       csvwriter = csv.writer(f)
       csvwriter.writerows(uni_vectors)

elif mode == "BUILD_FREQ_VEC_BI":
    ep, class_value, bodys = initParser(config)
    fb_bi  = FreqBuilder("bi_grams_dict_fin.json")
    bi_dict  = fb_bi.getDict()
    bi_vectors = []
    for i, b in tqdm(enumerate(bodys)):
        try:
            lemm = ep.preprocess(b)
            vec_bi = ep.buildFreqVec(lemm, bi_dict)
            vec_bi.append(class_value)
            bi_vectors.append(vec_bi)
        except Exception as e:
            print(f"[{i}]: {e}") 
            continue

    with open('spam_freq_vec_bi.csv', 'a') as f:
        csvwriter = csv.writer(f)
        csvwriter.writerows(bi_vectors)


#testing and debuging
else:
    fb = FreqBuilder("bi_grams_dict_all_en.json")
    fb.dumpSortedDict(file_out = "bi_grams_dict_all_en_sorted.txt")


    

    





