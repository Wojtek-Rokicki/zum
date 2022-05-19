import email
import traceback
from  tqdm import tqdm
from email import policy
from os import listdir
from os.path import isfile, join
import traceback

def getEmailBody(filename):
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


def dumpToFile(filename, text):
    with open(filename, "w", encoding="utf-8") as f:
        f.write(text)


def readEmailsBody(dir_path, out_dir):
    emails_files = [f for f in listdir(dir_path) if isfile(join(dir_path, f))]
    for ef in tqdm(emails_files):
        tmp = getEmailBody(dir_path + ef)
        if tmp:
            #dumpToFile(f"{out_dir + ef}_body", tmp)
            pass



# r = getEmailBody("sample2")
# dumpToFile("out.txt", r)
SPAM_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam\\'
SPAM_BODY_DIR = 'C:\Projekty\ZUM\zum\corpus\spam\spam_body\\'

readEmailsBody(SPAM_DIR, SPAM_BODY_DIR)

