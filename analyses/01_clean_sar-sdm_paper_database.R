#load raw data and prepare it for analyses

# load libraries #==================

library(dplyr)

# SAR-SDM paper database #=========================

# data from papers found in lit review

sarsdm_papers_raw <- read.csv("./data/raw-data/SAR-SDM_paper_database.csv")

str(sarsdm_papers_raw)

length(unique(sarsdm_papers_raw$species)) #546
length(unique(sarsdm_papers_raw$speciesID)) #593

# remove papers that were screened out at Level 3
# check that no species information was lost before moving on

remove <- sarsdm_papers_raw[which(sarsdm_papers_raw$Lev3_out=="1"),]
unique(remove$remove)
unique(remove$rationale)

sarsdm_papers_keep <- sarsdm_papers_raw[which(sarsdm_papers_raw$Lev3_out=="0"),]
unique(sarsdm_papers_keep$remove)
unique(sarsdm_papers_keep$rationale)

#sarsdm_papers_keep2<-subset(sarsdm_papers_raw,remove=="0"|remove=="2"|remove=="3"|is.na(remove))
length(unique(sarsdm_papers_keep$species)) #546, no species information lost when removing remove = 1
length(unique(sarsdm_papers_keep$speciesID)) #593, no species information lost when removing remove = 1

# no species information lost, can keep going 

# next, check that each paperID is only associated with one unique citation

for (ID in sarsdm_papers_keep$paperID) {
  
  check <- sarsdm_papers_keep[which(sarsdm_papers_keep$paperID==ID),]
  
  unique_cite <- length(unique(check$doc_citation))
  
  if (unique_cite > 1) {print(ID)}
  else {}
}

# check that species with paperID 0 don't have a non-zero paperID
# paperID 0 should mean that there is no paper associated with the species

for (sp in sarsdm_papers_keep$species){
  
  check <- sarsdm_papers_keep[which(sarsdm_papers_keep$species==sp),]
  
  id0 <- check[which(check$paperID=="0"),]
  
  if (nrow(id0)>0){
    
    num_paper_id <- length(unique(check$paperID))
    
    if (num_paper_id==1){}
    
    else if (num_paper_id>1){print(sp)}
  }
  
  else {}
  
}

# remove obsolete fields (sdm, excess obj fields)

sarsdm_papers_keep <- within(sarsdm_papers_keep, 
                             rm(sdm, obj_health, obj_commercial, obj_biotic, 
                             obj_biodiversity, obj_genetic, Canada, proj_future_detail,
                             proj_future_motive, proj_future_env_data, proj_present_detail,
                             back_details, back_motive, method, extent_km, Lev3_out))

write.csv(sarsdm_papers_keep,"./data/SAR-SDM_paper_database_clean.csv")

