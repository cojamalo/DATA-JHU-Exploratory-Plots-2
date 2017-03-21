## DATA-JHU-Exploratory-Plots-2
### Submission by Connor Lenio. Email: cojamalo@gmail.com
Completion Date: XXX ##, 2017

### Introduction to the Data
From "Exploratory Data Analysis Week 4 Project" instructions:

This assignment uses data from
the <a href="http://archive.ics.uci.edu/ml/">UC Irvine Machine
Learning Repository</a>, a popular repository for machine learning
datasets. In particular, we will be using the "Individual household
electric power consumption Data Set" which I have made available on
the course web site:


* <b>Dataset</b>: <a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip">Electric power consumption</a> [20Mb]

* <b>Description</b>: Measurements of electric power consumption in
one household with a one-minute sampling rate over a period of almost
4 years. Different electrical quantities and some sub-metering values
are available.


The following descriptions of the 9 variables in the dataset are taken
from
the <a href="https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption">UCI
web site</a>:

<ol>
<li><b>Date</b>: Date in format dd/mm/yyyy </li>
<li><b>Time</b>: time in format hh:mm:ss </li>
<li><b>Global_active_power</b>: household global minute-averaged active power (in kilowatt) </li>
<li><b>Global_reactive_power</b>: household global minute-averaged reactive power (in kilowatt) </li>
<li><b>Voltage</b>: minute-averaged voltage (in volt) </li>
<li><b>Global_intensity</b>: household global minute-averaged current intensity (in ampere) </li>
<li><b>Sub_metering_1</b>: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). </li>
<li><b>Sub_metering_2</b>: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. </li>
<li><b>Sub_metering_3</b>: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.</li>
</ol>

### The Scripts
The following are the instructions for implementing the plot#.R series of scripts with the source data to create the four desired plots.

### Working Directory
Please make sure your working directory contains the uncompressed contents from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

The script assumes that paths such as "./household_power_consumption.txt" are valid. Please confirm this is the case for you.

### Dependecies
The script assumes the following packages are either in your base R installation or have been installed:
- data.table
- dplyr
- lubridate

### RUN
Source the plot1.R script in your working directory that also contains the data. Substitute the plot # you want to recreate for the "1" in "plot1.R", such as "plot4.png," for instance.  

### The Process
I have also commented the code itself in each plot.R file, so feel free to follow along by looking at its contents.

The Data Import and Cleaning Steps are as follows:
- Import the data using fread, replacing '?' with NAs and keeping the headers, convert to tibble dataframe, and filter to desired dates (Date == "1/2/2007" | Date == "2/2/2007").
- Combine the date and time variables into a single Datetime character vector and convert to date-time format.
- Reorder dataframe variables to exclude old Date and Time character vectors
  
The Construct the Plot steps vary for each plot, but each version includes:
- A call to "png" with output file name and height and width parameters set
- The unique plot function calls to reproduce each plot
- A call to "dev.off" to end finalize the creation of the png file


### OUTPUT
When the script completes, your workspace will contain the imported data, df, and your working directory will now contain the final png image of the plot with its proper name such as "plot1.png.

Project coded by Connor Lenio ©2017. 



