library(httr)
library (readr)
library(tidyverse)

## httr settings
httr::set_config(httr::config(http_version = 0))

## Define path to Ingalls standards
urlfile="https://raw.githubusercontent.com/IngallsLabUW/Ingalls_Standards/master/Ingalls_Lab_Standards_NEW.csv"

## Isolate names of standards and select the first 10 elements for convenience
Ingalls_Standards <- read_csv(url(urlfile)) 
Standards_Names <- Ingalls_Standards[["Compound.Name"]][1:10] 

## Create an empty list for the loop to fill.
Looped_Names = list()

for (i in Standards_Names) {
  ## insert each standard name (i) into the httr request
  path <- paste("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/", i, 
                "/property/Title,MolecularFormula/CSV", sep = "")
  print(path)
  
  r <- GET(url = path) # Retrieve the actual data
  Sys.sleep(1) ## Pause to not overwhelm the PubChem database
  status_code(r) ## Stop for any errors
  content(r) ## Extract content from the request
  names <- read.csv(text = gsub("\t\n", "", r), sep = ",",
                    header = TRUE) ## Transform retrieved data to a useful format
  Looped_Names[[i]] <- names ## Fill empty list with names
}

Request_Results = bind_rows(Looped_Names) ## Transform to dataframe