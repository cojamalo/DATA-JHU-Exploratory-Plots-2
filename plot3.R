library(dplyr)
library(ggplot2)

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
##Question 3:
##Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreasreasns
##missions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make
## a plot answer this question.

##First, filter the data so that only observations from Baltimore City are present. 
##Then, group all of the data by year and type, and find the total emissions for each year - bal_tot_emi_year_type
bal_tot_emi_year_type <- pm25 %>% filter(fips == "24510") %>% group_by(year,type) %>% summarize(emissions_total = sum(Emissions))

##Reorder the type factor levels in a more logical way
bal_tot_emi_year_type$type <- factor(bal_tot_emi_year_type$type, levels = c("ON-ROAD", "NON-ROAD", "POINT", "NONPOINT"))

##Use ggplot to  construct a facetted barchart with four panels for each of the four emissions types. Add a linear regression line to accentuate the trend.
png("plot3.png", width = 600, height = 480)
ggplot(bal_tot_emi_year_type, aes(x = year, y = emissions_total, fill = type)) + 
  geom_bar(stat="identity")  + 
  geom_smooth(method="lm", se=FALSE) +
  facet_grid(.~type) +
  scale_x_continuous(breaks = c(1999,2002,2005,2008)) +
  labs(title = "Total PM2.5 Emissions In Balitmore City From All Sources by Year and Emissions Type", col = "Emissions Type", x = "Year", y = "Total Emissions (tons)") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
                                                                                                  
