import nltk


class FreqBuilder():
    def __init__(self, dict_path:str) -> None:
        
        self.__ngrams_dict = self.loadDict(dict_path)
        pass
    
    def loadDict(self, dict_path):
        pass
    
    def fitToDict(self, ngrams:list):
        for token in ngrams:
            if token not in self.__ngrams_dict:
                self.__ngrams_dict[token] = 1
            else:
                self.__ngrams_dict[token] += 1