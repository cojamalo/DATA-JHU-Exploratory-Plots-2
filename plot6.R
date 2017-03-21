library(dplyr)
library(ggplot2)
library(quantmod)

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
##Question 6:
##Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
##California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen greater changes over time in motor vehicle emissions?

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

##Use the category names to select only those observations in the data set that are related to vehicles and filter for Baltimore City and Los Angeles- balcali_veh_emi_by_year
balcali_veh_emi_by_year <- pm25 %>% 
                            filter((fips == "24510"|fips == "06037") & Short.Name %in% highway_short) %>% 
                              group_by(year,fips) %>% 
                                summarize(emissions_total = sum(Emissions)) 

##The following steps use various data wrangling techniques to rearrange the summarized data from the prior step, compute monthly % changes, and prepare the data
##for a call to ggplot that manipulates its logic in order to create a special facetted plot with two different y axes for each row.
balcali_veh_emi_by_year <- arrange(balcali_veh_emi_by_year, fips)
balcali_veh_emi_by_year$chg <- Delt(balcali_veh_emi_by_year$emissions_total)*100
balcali_veh_emi_by_year$chg[c(1,5)] <- 0

balcali_veh_emi_by_year <- bind_rows(balcali_veh_emi_by_year,balcali_veh_emi_by_year)
balcali_veh_emi_by_year$chart <- c(rep(1,8), rep(2,8))
balcali_veh_emi_by_year$value <- ifelse(balcali_veh_emi_by_year$chart == 1, balcali_veh_emi_by_year$emissions_total, balcali_veh_emi_by_year$chg)

balcali_veh_emi_by_year$fips <- factor(balcali_veh_emi_by_year$fips)
levels(balcali_veh_emi_by_year$fips) <- c("Los Angeles, CA", "Baltimore City, MD")
balcali_veh_emi_by_year$chart <- factor(balcali_veh_emi_by_year$chart)
levels(balcali_veh_emi_by_year$chart) <- c("Total Emissions (tons)", "% Change in Total Emissions from Previous Measurement Year")
balcali_veh_emi_by_year <- select(balcali_veh_emi_by_year, c(-emissions_total,-chg))

##Here is the final ggplot call, manipulating its logic to produce the special plot. View balcal_veh_emi_by_year before this step to see the final format of
##the data needed to make this plot.
png("plot6.png", width = 850, height = 550)
ggplot() + 
  geom_bar(stat="identity",data = subset(balcali_veh_emi_by_year, chart == "Total Emissions (tons)"),aes(x=year,y=value,fill=fips)) + 
  geom_smooth(data = subset(balcali_veh_emi_by_year, chart == "Total Emissions (tons)"),aes(x=year,y=value), method="lm", se=FALSE) +
  geom_bar(stat="identity",data = subset(balcali_veh_emi_by_year, chart == "% Change in Total Emissions from Previous Measurement Year"),aes(x=year,y=value,fill=fips)) + 
  facet_grid(chart~fips, scales = "free_y") +
  scale_x_continuous(breaks = c(1999,2002,2005,2008)) +
  labs(title = "Total PM2.5 Emissions and % Change in PM2.5 Emisions by Year in Balitmore City and Los Angeles from Motor Vehicles ", fill="Location",x = "Year", y = "% Change in Total Emissions                                    Total Emissions (tons)") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
