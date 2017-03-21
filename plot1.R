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
##Question 1:
##Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total 
##PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

##First, group all of the data by year and find the total emissions for each year - tot_emi_by_year
tot_emi_by_year <- pm25 %>% 
                    group_by(year) %>% 
                      summarize(emissions_total = sum(Emissions))

##Then, use the base plot package to make a barplot and add a linear regression line to accentuate the trend. Create a matrix version of tot_emi_by_year first.
matrix <- as.matrix(tot_emi_by_year)

png("plot1.png", width = 480, height = 480)
barplot(matrix[,2], names = matrix[,1], main = "Total PM2.5 Emissions From All Sources from 1999 to 2008", xlab = "Year", ylab = "Total Emissions (tons)")
abline(lm(emissions_total~c(1:4),data=tot_emi_by_year), col = "blue")
dev.off()
