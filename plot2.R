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
##Question 2:
##Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == 24510) from 1999 to 2008? Use the base plotting system 
##to make a plot answering this question.

##First, filter the data so that only observations from Baltimore City are present. 
##Then, group all of the data by year and find the total emissions for each year - bal_tot_emi_by_year
bal_tot_emi_by_year <- pm25 %>% 
                        filter(fips == "24510") %>% 
                          group_by(year) %>% 
                            summarize(emissions_total = sum(Emissions)) 

##Then, use the base plot package to make a barplot and add a linear regression line to accentuate the trend. Create a matrix version of tot_emi_by_year first.
matrix <- as.matrix(bal_tot_emi_by_year)

png("plot2.png", width = 520, height = 480)
barplot(matrix[,2], names = matrix[,1], main = "Total PM2.5 Emissions in Baltimore City, Maryland from 1999 to 2008", xlab = "Year", ylab = "Total Emissions (tons)")
abline(lm(emissions_total~c(1:4),data=bal_tot_emi_by_year), col = "blue")
dev.off()
