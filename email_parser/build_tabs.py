from os import listdir
from os.path import isfile, join
import re
from math import floor


def process_metrics(m_str):
    str_tmp = m_str.strip()
    str_tmp = str_tmp.replace(";", " & ")
    str_fin = str_tmp + "\\\\\n"
    return(str_fin)


def buildtab(metrics_formated_str):     
    tab_string = f'''
    \\begin{{tabular}}{{|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|p{{1.2cm}}|}}
    \hline
    TP & TN & FP & FN & R\_spam &  R\_ham & P\_spam & P\_ham & Acc & AUC  \\\\
    \hline
    {metrics_formated_str}
    \hline
    \end{{tabular}}
    '''
    return(tab_string)
    

def build_tab(metrics_formated_str):
    tab_string=f'''
    \\begin{{table}}[H] 
    \\centering 
    \\begin{{adjustbox}}{{width=1\\textwidth}}
    \\small
    \\begin{{tabular}}{{|l|l|l|l|l|l|l|l|l|l|l|}} 
    \\hline 
    & & & & & \multicolumn{{2}}{{|c|}}{{Recall}} & \multicolumn{{2}}{{|c|}}{{Precision}} & & \\\\
    Dataset & TP & TN & FP & FN & spam &  ham & spam & ham & Acc & AUC  \\\\
    \\hline 
    {metrics_formated_str}
    \\hline 
    \\end{{tabular}}
    \\end{{adjustbox}}
    \\end{{table}}
    '''
    return tab_string

def build_tab_svm(metrics_formated_str):
    tab_string=f'''
    \\begin{{table}}[H] 
    \\centering 
    \\begin{{adjustbox}}{{width=1\\textwidth}}
    \\small
    \\begin{{tabular}}{{|l|l|l|l|l|l|l|l|l|l|l|l|l|}} 
    \\hline 
    & & & & & & & \multicolumn{{2}}{{|c|}}{{Recall}} & \multicolumn{{2}}{{|c|}}{{Precision}} & &\\\\
    Dataset & kernel & cost & TP & TN & FP & FN & spam &  ham & spam & ham & Acc & AUC  \\\\
    \\hline 
    {metrics_formated_str}
    \\hline 
    \\end{{tabular}}
    \\end{{adjustbox}}
    \\end{{table}}
    '''
    return tab_string

def build_tab_svm_gamma(metrics_formated_str):
    tab_string=f'''
    \\begin{{table}}[H] 
    \\centering 
    \\begin{{adjustbox}}{{width=1\\textwidth}}
    \\small
    \\begin{{tabular}}{{|l|l|l|l|l|l|l|l|l|l|l|l|l|}} 
    \\hline 
    & & & & & & & \multicolumn{{2}}{{|c|}}{{Recall}} & \multicolumn{{2}}{{|c|}}{{Precision}} & &\\\\
    Dataset & kernel & gamma & TP & TN & FP & FN & spam &  ham & spam & ham & Acc & AUC  \\\\
    \\hline 
    {metrics_formated_str}
    \\hline 
    \\end{{tabular}}
    \\end{{adjustbox}}
    \\end{{table}}
    '''
    return tab_string

def build_tab_forrest(metrics_formated_str):
    tab_string=f'''
    \\begin{{table}}[H] 
    \\centering 
    \\begin{{adjustbox}}{{width=1\\textwidth}}
    \\small
    \\begin{{tabular}}{{|l|l|l|l|l|l|l|l|l|l|l|l|l|}} 
    \\hline 
    & & & & & & & \multicolumn{{2}}{{|c|}}{{Recall}} & \multicolumn{{2}}{{|c|}}{{Precision}} & &\\\\
    Dataset & tree\\_num & attrs\\_num & TP & TN & FP & FN & spam &  ham & spam & ham & Acc & AUC  \\\\
    \\hline 
    {metrics_formated_str}
    \\hline 
    \\end{{tabular}}
    \\end{{adjustbox}}
    \\end{{table}}
    '''
    return tab_string

def get_dataset_name_bayes(filename, rgx):
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1)
    else:
        raise ValueError("no match in filname")

    return dataset_name.replace("_", "\_")

def get_dataset_name_svm(filename, rgx):
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1)
        dataset_kernel = m.group(2)
        dataset_param = m.group(3)
    else:
        raise ValueError("no match in filname")

    return dataset_name.replace("_", "\_"), dataset_kernel, dataset_param

def get_dataset_name_forest(filename, rgx):
    m = re.search(rgx, filename)
    if m:
        dataset_name = m.group(1).replace("_", "\_")
        nt = m.group(2)
        mt = floor(float(m.group(3)))
    else:
        raise ValueError("no match in filname")

    return dataset_name, nt, mt


METRICS_PATH = "C:\\Projekty\\ZUM\\zum\\metrics\\metrics_rf\\"
rgx_bayes =r'^.*bayes_(.*)\.csv$'
rgx_svm_cost =r'^.*svm_(.*)_(.*)_c_(.*)\.csv$'
rgx_svm_gamma =r'^.*svm_(.*)(sigmoid|radial)g(.*)\.csv$'
rgx_forest =r'^.*forest_(.*)_(\d{2,3})nt_(.*)natr_\.csv$'
#model = 2 #svm_cost
model = 3 #svm_gamma
model = 4 #forest

metrics_files = [f for f in listdir(METRICS_PATH) if isfile(join(METRICS_PATH, f))]
metrics_formated_str  = ""
for i, ef in enumerate(metrics_files):
    with open(f"{METRICS_PATH}{ef}", "r", encoding="utf-8") as f:
        m_str = f.read()
        if model ==1:
            dn = get_dataset_name_bayes(ef, rgx_bayes)
            tmp_str = process_metrics(m_str)
            metrics_formated_str += f"{dn} & {tmp_str}"
        elif model == 2:
            dn, d_ker, d_par = get_dataset_name_svm(ef, rgx_svm_cost)
            tmp_str = process_metrics(m_str)
            metrics_formated_str += f"{dn} & {d_ker} & {d_par} & {tmp_str}"
        elif model == 3:
            dn, d_ker, d_par = get_dataset_name_svm(ef, rgx_svm_gamma)
            tmp_str = process_metrics(m_str)
            metrics_formated_str += f"{dn} & {d_ker} & {d_par} & {tmp_str}"
        elif model == 4:
            dn, nt, mt = get_dataset_name_forest(ef, rgx_forest)
            tmp_str = process_metrics(m_str)
            metrics_formated_str += f"{dn} & {nt} & {mt} & {tmp_str}"
           

t_str = build_tab_forrest(metrics_formated_str)
print(t_str)



