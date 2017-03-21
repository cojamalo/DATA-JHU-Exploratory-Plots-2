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
##Question 4:
##Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

##First, identify what observations involved coal combusion. Use the following loop to find what columns
##may be relevant:
#name_vector <- c()
#for (e in names(pm25)) {
#  if(length(grep("coal|Coal", levels(pm25[[e]]))) != 0 & length(grep("comb|Comb", levels(pm25[[e]]))) != 0) {
#    name_vector <- c(name_vector, e)
#  }
#}

##The outcome of the search in name_vector were:
#"Short.Name"     "EI.Sector"      "SCC.Level.Four"

##Examine each of the possible columns for useful information using grep calls such as:
#coal <- grep("coal|Coal", levels(pm25$Short.Names))

##The Short.Names column was selected as most useful.
##If I were analyzing this dataset professionally, I would have asked for more information on what categories
##to use to isolate the coal combustion observations.

##Next, isolate those category names that match coal combustion for Short.Name
coal <- grep("coal|Coal", levels(pm25$Short.Name))
coaln <- levels(pm25$Short.Name)[coal]
coalcomb_shortnames<- coaln[grep("comb|Comb", coaln)]

##Use the category names to select only those observations in the data set that are related to coal combustion - coalcomb
coalcomb <- pm25 %>% 
              filter(Short.Name %in% coalcomb_shortnames) %>% 
                droplevels
##Group the data by year and find the total emissions - coalcomb_by_year
coalcomb_by_year <- coalcomb %>% group_by(year) %>% summarize(emissions_total = sum(Emissions)) 

##Then, use the base plot package to make a barplot and add a linear regression line to accentuate the trend. Create a matrix version of tot_emi_by_year first.
matrix <- as.matrix(coalcomb_by_year)

png("plot4.png", width = 600, height = 500)
barplot(matrix[,2], names = matrix[,1], main = "Total PM2.5 Emissions from Coal Combustion-related Sources from 1999 to 2008", ylim = c(0,7e+05),xlab = "Year", ylab = "Total Emissions (tons)")
abline(lm(emissions_total~c(1:4),data=coalcomb_by_year), col = "blue")
dev.off()

