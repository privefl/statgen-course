library(bigreadr)

# reference panel to compute LD from
gzip <- runonce::download_file(
  "https://vu.data.surfsara.nl/index.php/s/VZNByNwpD8qqINe/download",
  fname = "g1000_eur.zip", dir = "tmp-data")  # 488 MB
unzip(gzip, exdir = "tmp-data", overwrite = FALSE)
g1000_map <- fread2("tmp-data/g1000_eur.bim", select = c(1, 4),
                    col.names = c("chr", "pos"))

ind_keep <- with(g1000_map, which(
  (chr == 1 & pos > 7909373 - 15e5 & pos < 7909373 + 15e5) |
    (chr == 19 & pos > 45417638 - 15e5 & pos < 46384830 + 15e5)))

library(bigsnpr)
library(dplyr)
snp_readBed2("tmp-data/g1000_eur.bed", ind.col = ind_keep, backingfile = tempfile()) %>%
  snp_attach() %>%
  snp_writeBed("tmp-data/g1000_eur_small.bed")

setwd("tmp-data")
zip("g1000_eur_2loci.zip",
    paste0("g1000_eur_small", c(".bed", ".bim", ".fam")))
setwd("..")


# GWAS summary statistics
tgz <- runonce::download_file(
  "https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90012001-GCST90013000/GCST90012102/GCST90012102_buildGRCh37.tsv.gz",
  dir = "tmp-data")
readLines(tgz, n = 3)
FT <- fread2(tgz)
FT_2loci <- filter(FT, (chromosome == 1 & base_pair_location > 7909373 - 15e5 & base_pair_location < 7909373 + 15e5) |
                     (chromosome == 19 & base_pair_location > 45417638 - 15e5 & base_pair_location < 46384830 + 15e5))
bigreadr::fwrite2(FT_2loci, "tmp-data/FT_sumstats_2loci.tsv.gz", sep = "\t")
readLines(.Last.value, n = 3)
