# Exploratory Data Analysis programming assignment 1
# part 1
# R code for contructing plot 1: histogram of global active power

# check memory requirements to load data
    # 2,075,259 rows x 9 columns x 8 bytes/numeric
    2075259 * 9 * 8 
    # 149418648
    149418648/2^20 #2^20 bytes/MN
    # 142.4967 MB
    # 0.142 GB
    # this won't be a problem, but might be wise to jettison full dataset after subsetting

# make sure you're in the working directory with the data in it
    # this assumes you have already downloaded the data to your working directory 
    # (see assignment instructions for data and source)
    getwd()
    # change if necessary
    setwd("C:/Users/sherry/Documents/Coursera/Coursera_DS4_EDA/ExData_Plotting1")
    # getwd()

# load the data
    power <- read.table("household_power_consumption.txt", header = T, sep =";", na.strings ="?")
    str(power)
    summary(power)

# subset feb 1 and 2 2007
    # We will only be using data from the dates 2007-02-01 and 2007-02-02.
    # these are 1/2/2007 and 2/2/2007 in the current dd/mm/yyyy format
    
    twofebdays <- droplevels(power[power$Date == "1/2/2007" | power$Date == "2/2/2007", ])
    # check that the number of observations match expectations
    # 2 days x 24 hours x 60 min
    2*24*60 # 2880 observations; yes, this is what you get

# remove full dataset from memory
    rm(power)

# plot 1: histogram of global active power
    # construct the plot 
    hist(twofebdays$Global_active_power, 
         main ="Global Active Power", 
         xlab = "Global Active Power (kilowatts)",
         col = "red") # for red bars
    
    # save it to a PNG file with a width of 480 pixels and a height of 480 pixels (png default size)
    png(file = "plot1.png")
    hist(twofebdays$Global_active_power, 
         main ="Global Active Power", 
         xlab = "Global Active Power (kilowatts)",
         col = "red")
    dev.off()

