# Machine Learning Project
Spam filter - text classification algorithms - analysis


--Budowanie zbiorów--
Katalog email_parser zawiera skrypty w języku python wykorzystywane do budowy reprezentacji ngramowej oraz w emmbedingow
W celu wygenerowania zbioru należy wykorzystać plik email_pareser.py w otpowiednim trybie wyszególnionym w kodzie.


-- Badanie modeli i reprezentacji --
load_dataset.R - wczytanie zbioru z reprezentacją emmbedingową
load_Dataset_ngrams.R  = wczytanie zbioru z reprezentacją cześtościową 
RandomDorest.R - implementacja funckcji do badania klasyfikatora lasu losowego
svm.R - implementacja funckcji do badania klasyfikatora SVM
bayes.R - implementacja funckcji do badania klasyfikatora naiwnego bayesa
metrics.R - Wyznaczanie miar i krzywej ROC
utils.R - funkcje pomocnicze do generowania zbiorów testowych i trenujących 

testy_final.R - skrypt wykonujący testy modeli dla zadanych parametrów


-- Reprezentacje --
emmbeding - katalog z wektorami w reprezentacji embbedingowej
ngrams_dict - katalog z korpusem unigramowym
ngram_vec - katalog z reprezentacją częstościową 