spam_filenames <- list.files("./corpus/spam", full.names = TRUE)
ham_filenames <- list.files("./corpus/easy_ham", full.names = TRUE)
# to concatenate lists use append(list1, list2)

library(readr)
library(stringr)

spamassassin_df = data.frame(
  id = numeric(), mail_content = character(), is_spam = logical(), stringsAsFactors = FALSE
)

for (i in 1:length(ham_filenames)){
  file_content <- read_file(ham_filenames[i])
  mail_content <- str_extract(file_content, "\n\n(.|\n)*")
  spamassassin_df[i, ] <- c(i, mail_content, FALSE)
}

library(text2vec)