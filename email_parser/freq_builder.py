import nltk
import json
from os.path import exists
import os

class FreqBuilder():
    def __init__(self, dict_path:str) -> None:
        self.dict_filename = dict_path
        self.__ngrams_dict = self.loadDict(self.dict_filename)
        print(f"DICT_LEN: {len(self.__ngrams_dict)}")
    
    def loadDict(self, filename):
        if exists(filename):
            d = self.readDict(filename)
        else:
            d = self.initDict(filename)
        
        return d
    
    def readDict(self, filename):
        with open(filename, "r", encoding="utf-8") as f:
            d_json = f.read()
            ret = json.loads(d_json)
            return ret
        
    def initDict(self, filename):
        with open(filename, "w", encoding="utf-8") as f:
            new_dict = {}
            f.write(json.dumps(new_dict))
            
            return new_dict
    
                
    def saveDict(self):
        tmp_filename = self.dict_filename + "_tmp"
        with open(tmp_filename, "w", encoding="utf-8") as f:
            f.write(json.dumps(self.__ngrams_dict))
        
        os.remove(self.dict_filename)
        os.rename(tmp_filename, self.dict_filename)


    def dumpSortedDict(self, file_out):
        with open(file_out, "w", encoding='utf-8') as f:
            sort = sorted( ((v,k) for k,v in self.__ngrams_dict.items()), reverse=True)
            for s in sort:
                f.write(f"{s}\n")
                
    def getDict(self):
        return self.__ngrams_dict
        

    def fitToDict(self, ngrams:list):
        for token in ngrams:
            if token not in self.__ngrams_dict:
                self.__ngrams_dict[token] = 1
            else:
                self.__ngrams_dict[token] += 1