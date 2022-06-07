
from os import listdir
from os.path import isfile, join
import re
from math import floor


def process_metrics(m_str):
    str_tmp = m_str.strip()
    metrics = str_tmp.split(";")
    auc = metrics[-2]
    return auc



def matchBayes(filename):
    rgx =r'^.*bayes_(.*)\.csv$'
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1).replace("_", "\_")

        return f"Bayes; {dataset_name}"
    else:
        return None


def matchSvm_cost(filename):
    rgx =r'^.*svm_(.*)_(.*)_c_(.*)\.csv$'
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1).replace("_", "\_")
        dataset_kernel = m.group(2)
        dataset_param = m.group(3)
        return f"SVM; {dataset_name}; kernel: {dataset_kernel}; gamma: {dataset_param}"
    else:
        return None

def matchSvm_gamma(filename):
    rgx =r'^.*svm_(.*)(sigmoid|radial)g(.*)\.csv$'
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1).replace("_", "\_")
        dataset_kernel = m.group(2)
        dataset_param = m.group(3)
        return f"SVM; {dataset_name}; kernel: {dataset_kernel}; gamma: {dataset_param}"
    else:
        return None

def matchFores(filename):
    #metrics_forest_data_15_max_50nt_31.831588084794natr_.csv
    rgx =r'^.*forest_(.*)_(\d{2,3})nt_(.*)natr_\.csv$'
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1).replace("_", "\_")
        nt = m.group(2)
        mt = floor(float(m.group(3)))
    
        return f"Random Forest; {dataset_name}; ntree: {nt}; mtry: {mt}"
    else:
        return None




def param_from_name(f_name):
    r =matchBayes(f_name)
    if r: return r
    r =matchSvm_cost(f_name)
    if r: return r
    r =matchSvm_gamma(f_name)
    if r: return r
    r =matchFores(f_name)
    if r: return r
    
    else:
        raise ValueError(f"DO not match any: {f_name}")
    

def build_tab_auc(metrics_formated_str):
    tab_string=f'''
    \\begin{{longtable}}{{| p{{.20\\textwidth}} | p{{.80\\textwidth}} |}}
    \\hline
    Recall ham & model  \\\\
    \\hline
    \\endhead
    {metrics_formated_str}
    \\hline
    \\end{{longtable}}
    '''
    return tab_string


METRICS_PATH1 = "C:\\Projekty\\ZUM\\zum\\metrics\\svm_gamma_metrics\\"
METRICS_PATH2 = "C:\\Projekty\\ZUM\\zum\\metrics\\svm_cost\\"
METRICS_PATH3 = "C:\\Projekty\\ZUM\\zum\\metrics\\bayes\\"
METRICS_PATH4 = "C:\\Projekty\\ZUM\\zum\\metrics\\metrics_rf_wojtek\\"
METRICS_PATH5 = "C:\\Projekty\\ZUM\\zum\\metrics\\metrics_rf\\"
metrics_files1 = [f"{METRICS_PATH1}{f}" for f in listdir(METRICS_PATH1) if isfile(join(METRICS_PATH1, f))]
metrics_files2 = [f"{METRICS_PATH2}{f}" for f in listdir(METRICS_PATH2) if isfile(join(METRICS_PATH2, f))]
metrics_files3 = [f"{METRICS_PATH3}{f}" for f in listdir(METRICS_PATH3) if isfile(join(METRICS_PATH3, f))]
metrics_files4 = [f"{METRICS_PATH4}{f}" for f in listdir(METRICS_PATH4) if isfile(join(METRICS_PATH4, f))]
metrics_files5 = [f"{METRICS_PATH5}{f}" for f in listdir(METRICS_PATH5) if isfile(join(METRICS_PATH5, f))]

metrics_files =  metrics_files1 + metrics_files2 + metrics_files3 + metrics_files4 + metrics_files5
#metrics_files =   metrics_files5
bests = []
for i, ef in enumerate(metrics_files):
    with open(f"{ef}", "r", encoding="utf-8") as f:
        m_str = f.read()
        auc = process_metrics(m_str)
        f_name = ef.split("\\")[-1]
        bests.append((auc, param_from_name(f_name)))

metrics_formated_str = ""
sorted = sorted(bests, key=lambda tup: tup[0], reverse=True)
for s in sorted:
    metrics_formated_str+= f"{s[0]} & {s[1]} \\\\\n "
    
r = build_tab_auc(metrics_formated_str)
print(r)
