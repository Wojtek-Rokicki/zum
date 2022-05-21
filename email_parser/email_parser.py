import email
import json
import traceback
from  tqdm import tqdm
from email import policy
from os import listdir
from os.path import isfile, join
import traceback
from spam_preprocessing import EmmailPreprocessing

class EmailParser(EmmailPreprocessing):
    def __init__(self) -> None:
        super().__init__()
    

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

    def buildFreqVec(body):
        pass
    
    def buildEmmbedding(body):
        pass

# r = getEmailBody("sample2")
# dumpToFile("out.txt", r)
import os
cwd = os.getcwd()
print(cwd)
with open("email_parser\parser_conf.json", "r", encoding="utf-8") as f:
    confg = json.loads(f.read())
     
#SPAM_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam\\'
#SPAM_BODY_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam_body\\'
EmmailPreprocessing.downloadNLTKPackages()


ep = EmailParser()
bodys = ep.readEmailsBody(confg["spam_dir"], max_files = 1 )

print(bodys)






