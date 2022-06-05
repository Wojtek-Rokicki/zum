import re
import nltk
from nltk.stem import WordNetLemmatizer 
from nltk import sent_tokenize
from nltk.stem.porter import PorterStemmer
from nltk.corpus import stopwords, wordnet
from nltk.corpus import wordnet as wn
import json

class EmmailPreprocessing:
    def __init__(self) -> None:
        self.stopwords = set(stopwords.words("english"))
        #eanglish words corpus
        self.nltk_eng_words = set(nltk.corpus.words.words())
        self.lemmatizer = WordNetLemmatizer()

    @classmethod
    def downloadNLTKPackages(cls):
        nltk.download('wordnet')
        nltk.download('omw-1.4')
        nltk.download('punkt')
        nltk.download('stopwords')
        nltk.download('averaged_perceptron_tagger')
        nltk.download('words')

    def cleanText(self, text):
        tmp = text
        #remove user reference
        #tmp = re.sub("@[A-Za-z0-9_]+","", tmp)
        #remove hashhtags
        #tmp = re.sub("#[A-Za-z0-9_]+","", tmp)
        #remove urls
        tmp = re.sub(r"http\S+", "", tmp)
        #tmp = re.sub(r"www.\S+", "", tmp)
        #split words connected with "-" wchich is needed for further processing
        tmp = re.sub(r"-", " ", tmp)
        # remove words longer than 45 characters
        # according to english dictionary the longest word:
        # "Pneumonoultramicroscopicsilicovolcanoconiosis" has 45 characters
        tmp = re.sub(r"\w{46,}", "", tmp)
        
        return tmp
    
    
    
    def preprocess(self, text:str, match_nltk_corpus = False):
        lowwer_text = text.lower()
        clean_text = self.cleanText(lowwer_text)
        #split into tokens
        tokens = nltk.word_tokenize(clean_text)
        
        #further cleaning
        words_tmp = [word for word in tokens if word.isalpha()]
        words = [x for x in words_tmp if x not in self.stopwords]
        
        #finde POS tags for better lemmatization, removes signs like , ( ) @ ...
        tagged = nltk.pos_tag(words)

        #lemmatize -> list of tuples
        lemms = [self.lemmatizer.lemmatize(word, pos=self.get_wordnet_pos(pos_tag)) 
                 for word, pos_tag in tagged]

        if match_nltk_corpus:
            lemms_ = [l for l in lemms if l in self.nltk_eng_words]
            lemms = lemms_
        
        return lemms
        
    def applyStopWords(self, words:dict):
        new_words = {}
        for k, v in words.items():
            if k not in self.stopwords:
                new_words[k] = v

        return new_words


    def get_wordnet_pos(self, treebank_tag):
        if treebank_tag.startswith('J'):
            return wordnet.ADJ
        elif treebank_tag.startswith('V'):
            return wordnet.VERB
        elif treebank_tag.startswith('N'):
            return wordnet.NOUN
        elif treebank_tag.startswith('R'):
            return wordnet.ADV
        else:
            #default value for lemmatize function
            return "n"

    

if __name__ == "__main__":
    with open("uni_grams_dict_fin.json", "r", encoding="utf-8") as f:
        d = json.loads(f.read())

    print(type(d))
    ep = EmmailPreprocessing()
    new_d = ep.applyStopWords(d)

    with open("out_dict.txt", "w", encoding='utf-8') as f:
        sort = sorted( ((v,k) for k,v in new_d.items()), reverse=True)
        for s in sort:
            f.write(f"{s}\n")

