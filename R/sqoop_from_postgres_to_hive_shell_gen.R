
#create a shell script to sqoop data from postgres to hive 
#assumes that you have postgres and hive running, both with the database fars created
#and the appropriate usernames and passwords
#make sure to change absolute directory below to your own
nbrRuns= 0; for(yr in 1975:2015){
  nbrRuns = nbrRuns + 1
  cat(paste0("

hdfs dfs -rmr /user/ibm/vehicle_",yr," 
sqoop import --connect jdbc:postgresql://localhost:5432/fars --username ibm --password passw0rd --table vehicle_",yr," --hive-import --hive-table fars.vehicle_",yr," -m 1       
hdfs dfs -rmr /user/ibm/accident_",yr," 
sqoop import --connect jdbc:postgresql://localhost:5432/fars --username ibm --password passw0rd --table accident_",yr," --hive-import --hive-table fars.accident_",yr," -m 1       
hdfs dfs -rmr /user/ibm/person_",yr," 
sqoop import --connect jdbc:postgresql://localhost:5432/fars --username ibm --password passw0rd --table person_",yr," --hive-import --hive-table fars.person_",yr," -m 1 "      
), file = "/home/ibm/projects/fars/data/input/mksqoop.sh",
append= ifelse(nbrRuns==1,F,T))
}

#run the file that you created: 
system("sh /home/ibm/projects/fars/data/input/mksqoop.sh")