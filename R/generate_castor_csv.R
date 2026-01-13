generate_castor_csv <- function(bidsdir='/Volumes/project/3022026.01/pep/ClinVars_2025_09_01', outputdir=paste(bidsdir,'derivatives',sep='/'), force=FALSE, intermediate_output=TRUE){

        script_dir <- "/Users/marjoh/Documents/work/code/PPP_imaging/R"
        library(tidyverse)
        #library(tidyjson)
        library(jsonlite)
        library(lubridate)
        
        # bidsdir <- 'P:/3022026.01/pep/ClinVars'
        
        ##### Set up intermediate output directory
        tmpdir <- paste(bidsdir, 'derivatives', 'tmp', sep='/')
        dir.create(tmpdir, showWarnings = FALSE, recursive = TRUE)
        files <- dir(tmpdir, '.*', full.names = TRUE)
        if(force){
                sapply(files, file.remove)
        }
        
        ##### JSON-to-CSV conversion #####
        source(str_c(script_dir, '/functions/convert_json_to_csv.R'))
        subjects <- dir(bidsdir, 'sub-.*')
        # set.seed(1234)
        # sample.int(length(subjects), 10)
        # subjects <- subjects[c(374, 180, 118, 481, 233, 403, 377, 271, 248, 218)]
        for(n in subjects){
                visits <- dir(paste(bidsdir,n,sep='/'), 'ses-.*Visit.*')
                for(v in visits){
                        outputname <- paste(n, v, 'json2csv.csv',sep='_')
                        outputname <- paste(tmpdir, outputname, sep='/')
                        convert_json_to_csv(bidsdir, n, v, outputname)
                }
        }
        
        ##### Variable documentation #####
        source(str_c(script_dir, '/functions/write_colnames_list.R'))
        write_colnames_list(tmpdir)
        
        ##### Read converted CSV files to data frame and write to file #####
        source(str_c(script_dir, '/functions/merge_csv_to_file.R'))
        fps <- dir(paste(tmpdir,sep='/'), 'sub.*.json2csv', full.names = TRUE)
        merged_csv_file <- paste(outputdir, '/merged_', today(), '.csv', sep='')
        merge_csv_to_file(fps, merged_csv_file)
        
        ##### Clean up intermediate output #####
        if(!intermediate_output){
                unlink(tmpdir, recursive = TRUE)
        }
        
        ##### Manipulate castor csv file #####
        source(str_c(script_dir, '/functions/manipulate_castor_csv.R'))
        manipulate_castor_csv(merged_csv_file)
        

}




