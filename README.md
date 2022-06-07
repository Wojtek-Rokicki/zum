# Machine Learning Project
Spam filter - text classification algorithms - analysis


--Budowanie zbiorów--<br>
Katalog email_parser zawiera skrypty w języku python wykorzystywane do budowy reprezentacji ngramowej oraz w emmbedingow<br>
W celu wygenerowania zbioru należy wykorzystać plik email_pareser.py w otpowiednim trybie wyszególnionym w kodzie.<br>

-- Badanie modeli i reprezentacji --<br>
load_dataset.R - wczytanie zbioru z reprezentacją emmbedingową<br>
load_Dataset_ngrams.R  = wczytanie zbioru z reprezentacją cześtościową <br>
RandomDorest.R - implementacja funckcji do badania klasyfikatora lasu losowego<br>
svm.R - implementacja funckcji do badania klasyfikatora SVM<br>
bayes.R - implementacja funckcji do badania klasyfikatora naiwnego bayesa<br>
metrics.R - Wyznaczanie miar i krzywej ROC<br>
utils.R - funkcje pomocnicze do generowania zbiorów testowych i trenujących <br>
testy_final.R - skrypt wykonujący testy modeli dla zadanych parametrów<br>

-- Reprezentacje --<br>
emmbeding - katalog z wektorami w reprezentacji embbedingowej<br>
ngrams_dict - katalog z korpusem unigramowym<br>
ngram_vec - katalog z reprezentacją częstościową <br>