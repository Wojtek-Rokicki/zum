import email
import json
import traceback
from  tqdm import tqdm
from email import policy
from os import listdir
from os.path import isfile, join
import traceback
from spam_preprocessing import EmmailPreprocessing
#from gensim.models import Word2Vec
from gensim.models import KeyedVectors
from gensim.scripts.glove2word2vec import glove2word2vec
from gensim.test.utils import datapath, get_tmpfile
from sys import exit
import spacy

class EmailParser(EmmailPreprocessing):
    def __init__(self, source_word_vec_file = "", use_spacy = False) -> None:
        super().__init__()
        #self.w2v_model = KeyedVectors.load_word2vec_format(
            # 'data/GoogleGoogleNews-vectors-negative300.bin', binary=True)
        self.use_spacy = use_spacy
        if self.use_spacy:
            self.w2v_model = spacy.load('en_core_web_md')
        else:
            self.w2v_model = KeyedVectors.load_word2vec_format(source_word_vec_file, binary=False)


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

    def buildFreqVec(self, body):
        pass
    
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
        return vec

    @classmethod
    def glove2w2v(cls, source_file, out_file):
        glove_file = datapath(source_file)
        tmp_file = get_tmpfile(out_file)
        _ = glove2word2vec(glove_file, tmp_file)

# r = getEmailBody("sample2")
# dumpToFile("out.txt", r)
import os
cwd = os.getcwd()
print(cwd)
with open("email_parser\parser_conf.json", "r", encoding="utf-8") as f:
    config = json.loads(f.read())
     
#SPAM_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam\\'
#SPAM_BODY_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam_body\\'
EmmailPreprocessing.downloadNLTKPackages()

#EmailParser.glove2w2v(config["w2v_model"], config["w2v_model"] + "_w2v")

ep = EmailParser(config["w2v_model"], use_spacy=True)
bodys = ep.readEmailsBody(config["spam_dir"], max_files = 1 )

print(len(bodys))
emmbedings = []
for b in bodys:
    lemm = ep.preprocess(b)
    e = ep.buildEmmbedding(lemm)
    emmbedings.append(e)

for e in emmbedings:
    print(len(e))







