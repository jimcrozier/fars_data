#assumes that you successfully ran sqoop_from_postgres_to_hive_shell_gen, and the associated shell file 

#unian all years data:
create_union_table = function(tbl_nm, max_yr){
  #get all year variable names: 
  colvars = list()
  nbrRuns = 0 ;for(yr in 1975:max_yr){
    nbrRuns = nbrRuns + 1 
    colvars[[nbrRuns]] = data.frame(vars=tbl(sc, paste0(tbl_nm,"_",yr))[[2]]$vars, stringsAsFactors = F)
  }
  
  #create oldest and newst intersection: 
  vars = intersect(colvars[[1]]$vars, colvars[[NROW(colvars)]]$vars)
  
  #check and make sure that these vars in are in all years:
  out = list()
  nbrRuns = 0 ;for(yr in 1975:max_yr){
    nbrRuns = nbrRuns + 1 
    out[[nbrRuns]] = data.frame(isvars = min( vars %in% colvars[[nbrRuns]]$vars))
  }
  
  out = do.call("rbind", out)
  if (min(out)<1) return# should be 1
 
  
  #so, going to create a hive script 
  nbrRuns= 0; for(yr in 1975:max_yr){
    nbrRuns = nbrRuns + 1
    cat(paste0(ifelse(yr==1975,paste0("drop table fars.",tbl_nm,"_all; \ncreate table fars.",tbl_nm,"_all as select * from ("),  "" ),
               "
           select ", paste(vars, collapse = ","),
               " from fars.",tbl_nm,"_", yr, ifelse(yr==max_yr,")aa;",  " union all  " )
    ), file = "/home/ibm/projects/fars/data/input/mkvehhivetbl.sql",
    append= ifelse(yr==1975,FALSE,  TRUE ))
  }
  #run the script 

}

#run for accident
create_union_table("accident",2015)
system(" hive -f /home/ibm/projects/fars/data/input/mkvehhivetbl.sql ")

#run for person
create_union_table("person",2015)
system(" hive -f /home/ibm/projects/fars/data/input/mkvehhivetbl.sql ")

#run for vehicle 
create_union_table("vehicle",2015)
system(" hive -f /home/ibm/projects/fars/data/input/mkvehhivetbl.sql ")
