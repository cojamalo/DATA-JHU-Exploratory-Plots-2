library(dplyr)

### Working Directory
##Please make sure your working directory contains the uncompressed rds files from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
##The script assumes that paths such as "./Source_Classification_Code.rds" are valid. Please confirm this is the case for you.

###Data Import and Cleaning Steps
##Import the data from the working directory into two variables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Merge the two data sets by the SCC code so all information is present in one dataframe
pm25 <- full_join(NEI,SCC, by = "SCC") %>% 
  tbl_df %>% 
  filter(!is.na(Emissions))

###Construct the Plot
##Question 5:
##How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

##First, identify what observations involve motor vehicles. Use the following loop to find what columns
##may be relevant:
#name_vector <- c()
#for (e in names(pm25)) {
#  if(length(grep("veh|Veh", levels(pm25[[e]]))) != 0) {
#    name_vector <- c(name_vector, e)
#  }
#}

##The outcome of the search in name_vector was:
#"Short.Name"      "EI.Sector"       "SCC.Level.Two"   "SCC.Level.Three"  "SCC.Level.Four" 

##Examine each of the possible columns for useful information using grep calls such as:
#vehicles <- grep("veh|Veh", levels(pm25$Short.Name))

##The Short.Names column was selected as most useful.
##If I were analyzing this dataset professionally, I would have asked for more information on what categories
##to use to isolate the motor vehicle observations.

##Next, isolate those category names that match motor vehicles for Short.Name
highway <- grep("highway|Highway", levels(pm25$Short.Name))
highway_short<-levels(pm25$Short.Name)[highway]

##Use the category names to select only those observations in the data set that are related to vehicles and filter for Baltimore City - bal_veh_emi_by_year
bal_veh_emi_by_year <- pm25 %>% 
                        filter(fips == "24510" & Short.Name %in% highway_short) %>% 
                          group_by(year) %>% 
                            summarize(emissions_total = sum(Emissions)) 
##Then, use the base plot package to make a barplot and add a linear regression line to accentuate the trend. Create a matrix version of tot_emi_by_year first.
matrix <- as.matrix(bal_veh_emi_by_year)

png("plot5.png", width = 640, height = 500)
barplot(matrix[,2], names = matrix[,1], main = "Total PM2.5 Emissions in Baltimore City, Maryland by Motor Vehicles from 1999 to 2008", xlab = "Year", ylab = "Total Emissions (tons)")
abline(lm(emissions_total~c(1:4),data=bal_veh_emi_by_year), col = "blue")
dev.off()
