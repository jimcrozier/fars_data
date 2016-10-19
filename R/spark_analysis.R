#load the library
library(sparklyr)
#set you spark home environment variable: 
Sys.setenv(SPARK_HOME="/usr/iop/4.2.0.0/spark")

#set you configuration
config <- spark_config("/Users/robertcrozier/Documents/projects/spark_enablement/config.yml")
config[["sparklyr.defaultPackages"]] <- NULL
#create you spark context: 
sc <- spark_connect(master = "local", config=config,
                    spark_home = Sys.getenv("SPARK_HOME"), version ='1.6.1')
#load the dplry library:
library(dplyr)
#copy a few temp files to your spark context: 
iris_tbl <- copy_to(sc, iris,overwrite = TRUE)

#connect to hive table: 
dbGetQuery(sc, "USE fars")  

test_tbl = tbl(sc, paste0("vehicle_1975"))
test_tbl %>% summarise(n())

vehicle_all_tbl = tbl(sc, "vehicle_all")
vehicle_all_tbl %>% summarise(n())
vehicle_vars = vehicle_all_tbl[[2]]$vars

person_all_tbl = tbl(sc, "person_all")
person_all_tbl %>% summarise(n())
person_vars = person_all_tbl[[2]]$vars

accident_all_tbl = tbl(sc, "accident_all")
accident_all_tbl %>% summarise(n())
accident_vars = accident_all_tbl[[2]]$vars




