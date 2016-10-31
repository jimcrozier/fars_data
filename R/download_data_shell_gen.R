# download the data into the .. data/input folder


# *********************** BEFORE YOU RUN ********************************
# DO THIS FIRST - Set projectDir to where you'd like this project to go.
#                 
# 
#                 Tip - use the '~' character or tie it to your home directory,
#                       so you can run everything in this file from whatever 
#                       working directory you're in.

projectDir <- "~/Desktop/Projects"    # Jim's is "/home/ibm/projects"


setup = function(projectDir) {
  system(paste0("cd ",projectDir,"; touch setup.sh"))
  cat(paste0("
             cd ",projectDir,"
             mkdir fars
             mkdir fars/data
             mkdir fars/data/input"),
      file = paste0(projectDir,"/setup.sh"))
      system(paste0("sh ",projectDir,"/setup.sh"))
      
  system(paste0("rm ",projectDir,"/setup.sh"))
}


download_fars_data = function(yr,nbrRuns, projectDir){
  

  if(yr<2012){
    if(yr<1994 | yr>2000){
      cat(paste0("
                 
                 mkdir ",projectDir,"/fars/data/input/",yr,"
                 cd ",projectDir,"/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/DBF/FARS",yr,".zip 
                 unzip -o FARS",yr,".zip 
                 touch ",projectDir,"/fars/data/input/mkdat.sh
                 rm  FARS",yr,".zip"), file = paste0(projectDir,"/fars/data/input/mkdat.sh"),
          append= ifelse(nbrRuns==1,F,T) )
          #^ if number of runs != 1, append commands to mkdat.sh,
          #^ else, overwrite the file (which only happens on the first run!)
      
    }else {
      cat(paste0("
                 
                 mkdir ",projectDir,"/fars/data/input/",yr,"
                 cd ",projectDir,"/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/DBF/FARSDBF",substring(yr,3,4),".zip 
                 unzip -o FARSDBF",substring(yr,3,4),".zip 
                 touch ",projectDir,"/fars/data/input/mkdat.sh
                 rm  FARSDBF",substring(yr,3,4),".zip"), 
          file = paste0(projectDir,"/fars/data/input/mkdat.sh"),
          append= ifelse(nbrRuns==1,F,T))
    }
  } else {
    
    # Why is 2012 special?
    if(yr==2012){
      
      cat(paste0("
                 
                 mkdir ",projectDir,"/fars/data/input/",yr,"
                 cd ",projectDir,"/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/National/DBF/FARS",yr,".zip 
                 unzip -o FARS",yr,".zip 
                 touch ",projectDir,"/fars/data/input/mkdat.sh
                 rm  FARS",yr,".zip"), 
          file = paste0(projectDir,"/fars/data/input/mkdat.sh"),
          append= ifelse(nbrRuns==1,F,T)) 
    }else{
      
      cat(paste0("
                 
                 mkdir ",projectDir,"/fars/data/input/",yr,"
                 cd ",projectDir,"/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/National/FARS",yr,"NationalDBF.zip 
                 unzip -o FARS",yr,"NationalDBF.zip 
                 touch ",projectDir,"/fars/data/input/mkdat.sh
                 rm  FARS",yr,"NationalDBF.zip"), 
          file = paste0(projectDir,"/fars/data/input/mkdat.sh"),
          append= ifelse(nbrRuns==1,F,T)) 
    }
    
    
  }  
}

#create shell script by appending all years:
setup(projectDir)

nbrRuns = 0;  # number of runs
for(yr in 1975:2015){
  nbrRuns = nbrRuns + 1
  download_fars_data(yr, nbrRuns, projectDir)
}
#run the shell script 
system(paste0("sh ",projectDir,"/fars/data/input/mkdat.sh"))

