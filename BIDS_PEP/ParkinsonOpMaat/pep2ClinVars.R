library(tidyverse)

# Define input and output directories
# dPEP_HomeQuest <- 'P:/3022026.01/pep/download2/'
# dPEP_Visit <- 'P:/3022026.01/pep/download2/'
# dPEP_COVID <- 'P:/3022026.01/pep/download2/'
dPEP <- '/project/3022026.01/pep/download_ClinVars_2025_09_01'
dClinVars <- '/project/3022026.01/pep/ClinVars_2025_09_01'

# Clean out output directory
force = FALSE
if(dir.exists(dClinVars) & force == TRUE){
        unlink(dClinVars, recursive = TRUE)
        dir.create(file.path(dClinVars,'derivatives','tmp'), recursive = TRUE)
}else{
        dir.create(file.path(dClinVars,'derivatives','tmp'), recursive = TRUE)
}

# dContents_HomeQuest <- dir(dPEP_HomeQuest)
# idx_HomeQuest <- grep('^[A-Z0-9]', dContents_HomeQuest)
# Subjects_HomeQuest <- dContents_HomeQuest[idx_HomeQuest]
# 
# dContents_Visit <- dir(dPEP_Visit)
# idx_Visit <- grep('^[A-Z0-9]', dContents_Visit)
# Subjects_Visit <- dContents_Visit[idx_Visit]
# 
# dContents_COVID <- dir(dPEP_COVID)
# idx_COVID <- grep('^[A-Z0-9]', dContents_COVID)
# Subjects_COVID <- dContents_Visit[idx_COVID]

dContents <- dir(dPEP)
idx <- grep('^POM', dContents)
Subjects <- dContents[idx]

# Subjects = unique(c(Subjects_HomeQuest, Subjects_Visit, Subjects_COVID))
count=length(Subjects)
for(Sub in Subjects){
  
  start <- proc.time()
        
        # # Find pseudonym
        # dSub <- paste(dPEP_HomeQuest, Sub, sep='')
        # pseudonym <- paste('sub-POMU', substr(Sub,1,16), sep='')
        # 
        # # Collect all files that need to be copied to ClinVars
        # download_HomeQuest_files <- list.files(paste(dPEP_HomeQuest, Sub, sep = ''), full.names = TRUE)
        # download_HomeQuest_files <- download_HomeQuest_files[str_detect(download_HomeQuest_files, 'Castor.')]
        # download_files  <- list.files(paste(dPEP_Visit, Sub, sep = ''), full.names = TRUE)
        # download_files <- download_files[str_detect(download_files, 'Castor.')]
        # download_COVID_files  <- list.files(paste(dPEP_COVID, Sub, sep = ''), full.names = TRUE)
        # download_COVID_files <- download_COVID_files[str_detect(download_COVID_files, 'Castor.')]
        # all_files <- unique(c(download_HomeQuest_files, download_files, download_COVID_files))
        
        # Find pseudonym
        dSub <- paste(dPEP, Sub, sep='')
        pseudonym <- paste0('sub-', Sub)
        
        # Check if pseudonym has been bidsd already
        spath <- paste(dClinVars,pseudonym,sep='/')
        sdirs <- dir(spath)
        if(length(sdirs) > 0){
                cat('Skipping: ', pseudonym, ' already has data in bids format\n', sep='')
                next
        }
        
        # Collect all files that need to be copied to ClinVars
        download_files  <- list.files(file.path(dPEP, Sub), full.names = TRUE)
        fid = str_detect(download_files,'DiagnosisInformation')
        download_files <- download_files[!fid]
        all_files <- unique(download_files)
        
        # DEPRECATED: inefficient solution
        # for(f in all_files){
        #         fname <- basename(f)
        #         # Determine which folder to put a file in based on its name
        #         if(str_detect(fname, 'Castor.HomeQuestionnaires1') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMHomeQuestionnaires1'
        #         }else if(str_detect(fname, 'Castor.HomeQuestionnaires2') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMHomeQuestionnaires2'
        #         }else if(str_detect(fname, 'Castor.HomeQuestionnaires3') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMHomeQuestionnaires3'
        #         }else if(str_detect(fname, 'Castor.HomeQuestionnaires.Visit1') & str_detect(fname, 'PIT')){
        #                 subfolder <- 'PITHomeQuestionnaires1'
        #         }else if(str_detect(fname, 'Castor.HomeQuestionnaires.Visit2') & str_detect(fname, 'PIT')){
        #                 subfolder <- 'PITHomeQuestionnaires2'
        #         }else if(str_detect(fname, 'Castor.Visit1') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMVisit1'
        #         }else if(str_detect(fname, 'Castor.Visit2') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMVisit2'
        #         }else if(str_detect(fname, 'Castor.Visit3') & !str_detect(fname, 'PIT')){
        #                 subfolder <- 'POMVisit3'
        #         }else if(str_detect(fname, 'PIT.Castor.Visit.Visit_1')){
        #                 subfolder <- 'PITVisit1'
        #         }else if(str_detect(fname, 'PIT.Castor.Visit.Visit_2')){
        #                 subfolder <- 'PITVisit2'
        #         }else if(str_detect(fname, 'COVID.') & str_detect(fname, 'PackBasic')){
        #                 subfolder <- 'COVIDbasic'
        #         }else if(str_detect(fname, 'COVID.') & str_detect(fname, 'PackFinal')){
        #                 subfolder <- 'COVIDfinal'
        #         }else if(str_detect(fname, 'COVID.') & str_detect(fname, 'PackWeek1')){
        #                 subfolder <- 'COVIDweek1'
        #         }else if(str_detect(fname, 'COVID.') & str_detect(fname, 'PackWeek2')){
        #                 subfolder <- 'COVIDweek2'
        #         }else if(str_detect(fname, 'COVID.') & str_detect(fname, 'CovPackDaily')){
        #                 subfolder <- 'COVIDdaily'
        #         }else if(str_detect(fname, 'DD_InflammationMarkers') & str_detect(fname, 'Visit1')){
        #                 subfolder <- 'POMVisit1'
        #         }else if(str_detect(fname, 'DD_InflammationMarkers') & str_detect(fname, 'Visit2')){
        #                 subfolder <- 'POMVisit2'
        #         }else if(str_detect(fname, 'DD_InflammationMarkers') & str_detect(fname, 'Visit3')){
        #                 subfolder <- 'POMVisit3'
        #         }else if(str_detect(fname, 'Johansson2023_ClinicalSubtyping') & str_detect(fname, 'Visit1')){
        #                 subfolder <- 'POMVisit1'
        #         }else if(str_detect(fname, 'Johansson2023_ClinicalSubtyping') & str_detect(fname, 'Visit2')){
        #                 subfolder <- 'POMVisit2'
        #         }else if(str_detect(fname, 'Johansson2023_ClinicalSubtyping') & str_detect(fname, 'Visit3')){
        #                 subfolder <- 'POMVisit3'
        #         }else if(str_detect(fname, 'Castor.MedChanges')){
        #                 subfolder <- 'MedChanges'
        #         }else if(str_detect(fname, 'Castor.Folup.YearlyQs')){
        #                 subfolder <- 'YearlyQs'
        #         }else if(str_detect(fname, 'DD_GeneticScreening')){
        #                 subfolder <- 'GeneticScreening'
        #         }
        # 
        #         destination <- paste(dClinVars, '/', pseudonym, '/ses-', subfolder, sep = '')
        #         if(!dir.exists(destination)) dir.create(destination, recursive = TRUE)
        #         new_file <- paste(destination, '/', fname, '.json', sep='')
        #         file.copy(f, new_file)
        # 
        # }
        
        # Rule table for file to subfolder mapping
        rules <- tibble::tribble(
          ~pattern1,                                   ~pattern2,        ~subfolder,
          "Castor.HomeQuestionnaires1",                "^(?!.*PIT)",     "POMHomeQuestionnaires1",
          "Castor.HomeQuestionnaires2",                "^(?!.*PIT)",     "POMHomeQuestionnaires2",
          "Castor.HomeQuestionnaires3",                "^(?!.*PIT)",     "POMHomeQuestionnaires3",
          "Castor.HomeQuestionnaires.Visit1",          "PIT",            "PITHomeQuestionnaires1",
          "Castor.HomeQuestionnaires.Visit2",          "PIT",            "PITHomeQuestionnaires2",
          "Castor.Visit1",                             "^(?!.*PIT)",     "POMVisit1",
          "Castor.Visit2",                             "^(?!.*PIT)",     "POMVisit2",
          "Castor.Visit3",                             "^(?!.*PIT)",     "POMVisit3",
          "PIT.Castor.Visit.Visit_1",                  NA,               "PITVisit1",
          "PIT.Castor.Visit.Visit_2",                  NA,               "PITVisit2",
          "COVID.",                                    "PackBasic",      "COVIDbasic",
          "COVID.",                                    "PackFinal",      "COVIDfinal",
          "COVID.",                                    "PackWeek1",      "COVIDweek1",
          "COVID.",                                    "PackWeek2",      "COVIDweek2",
          "COVID.",                                    "CovPackDaily",   "COVIDdaily",
          "DD_InflammationMarkers.*Visit1",             NA,               "POMVisit1",
          "DD_InflammationMarkers.*Visit2",             NA,               "POMVisit2",
          "DD_InflammationMarkers.*Visit3",             NA,               "POMVisit3",
          "DD_plasma.*Visit1",                         NA,               "POMVisit1",
          "DD_plasma.*Visit2",                         NA,               "POMVisit2",
          "DD_plasma.*Visit3",                         NA,               "POMVisit3",
          "Johansson2023_ClinicalSubtyping.*Visit1",    NA,               "POMVisit1",
          "Johansson2023_ClinicalSubtyping.*Visit2",    NA,               "POMVisit2",
          "Johansson2023_ClinicalSubtyping.*Visit3",    NA,               "POMVisit3",
          "Castor.MedChanges",                          NA,               "MedChanges",
          "Castor.Folup.YearlyQs",                      NA,               "YearlyQs",
          "DD_GeneticScreening",                        NA,               "GeneticScreening",
          "CogPDim",                                   NA,               "CogPDim"
        )

        # Subfolder mapping function
        get_subfolder <- function(fname) {
          hit <- which(
            str_detect(fname, rules$pattern1) &
              (is.na(rules$pattern2) | str_detect(fname, rules$pattern2))
          )[1]
          rules$subfolder[hit]
        }

        # Assemble file destinations
        fnames <- basename(all_files)
        subfolders <- vapply(fnames, get_subfolder, character(1))
        destinations <- file.path(dClinVars, pseudonym, paste0("ses-", subfolders))
        new_files <- file.path(destinations, paste0(fnames, ".json"))

        # Create directories
        unique_dirs <- unique(destinations)
        if(.Platform$OS.type == 'unix'){
          system2('mkdir', c('-p', unique_dirs))
        }else{
          for (d in unique_dirs){
            if (!dir.exists(d)) {
              dir.create(d, recursive = TRUE)
            }
          }
        }

        # Copy files
        for (idx in seq_along(all_files)) {
          if(.Platform$OS.type == 'unix'){
            system2('rsync', c('-a', shQuote(all_files[idx]), shQuote(new_files[idx])))
          }else{
            file.copy(all_files[idx], new_files[idx], copy.date = TRUE)
          }
        }
        
        elapsed <- (proc.time() - start)["elapsed"]
        count <- count-1
        cat(sprintf('Copied files for %s in %.2f seconds. Subjects remaining: %i\n', pseudonym, elapsed, count))
        
}

