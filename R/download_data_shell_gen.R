
#download the data into the .. data/input folder, you will need to create these folders
#and change the absolute file names below:
download_fars_data = function(yr,nbrRuns){
  
  if(yr<2012){
    if(yr<1994 | yr>2000){
      cat(paste0("
                 
                 mkdir /home/ibm/projects/fars/data/input/",yr,"
                 cd /home/ibm/projects/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/DBF/FARS",yr,".zip 
                 unzip -o FARS",yr,".zip 
                 rm  FARS",yr,".zip"), file = "/home/ibm/projects/fars/data/input/mkdat.sh",
          append= ifelse(nbrRuns==1,F,T) )
    }else {
      cat(paste0("
                 
                 mkdir /home/ibm/projects/fars/data/input/",yr,"
                 cd /home/ibm/projects/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/DBF/FARSDBF",substring(yr,3,4),".zip 
                 unzip -o FARSDBF",substring(yr,3,4),".zip 
                 rm  FARSDBF",substring(yr,3,4),".zip"), 
          file = "/home/ibm/projects/fars/data/input/mkdat.sh",
          append= ifelse(nbrRuns==1,F,T)) 
      
    }
  } else {
    
    if(yr==2012){
      
      cat(paste0("
                 
                 mkdir /home/ibm/projects/fars/data/input/",yr,"
                 cd /home/ibm/projects/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/National/DBF/FARS",yr,".zip 
                 unzip -o FARS",yr,".zip 
                 rm  FARS",yr,".zip"), 
          file = "/home/ibm/projects/fars/data/input/mkdat.sh",
          append= ifelse(nbrRuns==1,F,T)) 
    }else{
      
      cat(paste0("
                 
                 mkdir /home/ibm/projects/fars/data/input/",yr,"
                 cd /home/ibm/projects/fars/data/input/",yr,"             
                 wget ftp://ftp.nhtsa.dot.gov/FARS/",yr,"/National/FARS",yr,"NationalDBF.zip 
                 unzip -o FARS",yr,"NationalDBF.zip 
                 rm  FARS",yr,"NationalDBF.zip"), 
          file = "/home/ibm/projects/fars/data/input/mkdat.sh",
          append= ifelse(nbrRuns==1,F,T)) 
    }
    
    
  }  
}

#create shell script by appending all years:
nbrRuns = 0;
for(yr in 1975:2015){
  nbrRuns = nbrRuns + 1
  download_fars_data(yr, nbrRuns)
}
#run the shell script 
system("sh /home/ibm/projects/fars/data/input/mkdat.sh")

