
#this file assumes that you have postgres, a username and a password, and a database called fars
#also need to change the file directory names below

library(RPostgreSQL)
# # loads the PostgreSQL driver
 drv <- dbDriver("PostgreSQL")
# # creates a connection to the postgres database
# # note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "fars",user = "ibm",password="passw0rd", host = "localhost", port = 5432)

library(foreign)

write_to_db = function(yr){
  #list the files for years 
  files = list.files(paste0("/home/ibm/projects/fars/data/input/",yr))
  person_file = files[grepl("^per",files,ignore.case=T) & !grepl("aux",files,ignore.case=T)]
  accident_file = files[grepl("^acc",files,ignore.case=T) & !grepl("aux",files,ignore.case=T)]
  vehicle_file = files[grepl("^veh",files,ignore.case=T) & !grepl("aux|nit",files,ignore.case=T) ]
  
  person = read.dbf(paste0("/home/ibm/projects/fars/data/input/",yr,"/",person_file))
  accident = read.dbf(paste0("/home/ibm/projects/fars/data/input/",yr,"/",accident_file))
  vehicle = read.dbf(paste0("/home/ibm/projects/fars/data/input/",yr,"/",vehicle_file))
  
  dbWriteTable(con, paste0("person_",yr), value = person, append = FALSE, row.names = FALSE)
  dbWriteTable(con, paste0("accident_",yr), value = accident, append = FALSE, row.names = FALSE)
  dbWriteTable(con, paste0("vehicle_",yr), value = vehicle, append = FALSE, row.names = FALSE)
}

#write out all years to the postgres database
for(yr in 1975:2015){
  print(yr)
  write_to_db(yr)
}
