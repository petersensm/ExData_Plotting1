# Exploratory Data Analysis programming assignment 1
# part 3
# R code for contructing plot 3: plot of the three sub metering values over time

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

# plot 3: plot of the three sub metering values over time
    # do I need to melt this and add a variable for color, or can I add each line one on top of the other?
    # I think I need to melt. but, if recall correctly, the melt does not like POSIXlt b/c it's a list
    # so, I could melt before doing the datetime variable. 
    # or I could convert POSIXlt to POSIXct
    
    # let's try the first strategy - melt the data, keeing Date, Time, and melting the Sub_metering values
    library(reshape)
    submetering_long <- melt(twofebdays, id = c("Date", "Time"), 
                             measure = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    
    # then generate a new variable datetime that combines both Date and Time in POSIXlt format
    # first, paste Date and Time together into a single character string called Datetimestring
    submetering_long$Datetimestring <- paste(as.character(submetering_long$Date), as.character(submetering_long$Time))
    str(submetering_long)
    # second, convert date and time to POSIXlt using strptime()
    # date format dd/mm/yyyy = %d/%m/%Y
    # time format hh:mm:ss = %H:%M:%S
    submetering_long$datetime <- strptime(submetering_long$Datetimestring, format = "%d/%m/%Y %H:%M:%S")
    str(submetering_long)
    
    # construct the plot 
    # rather than make a seperate vector for the colors, I'll try the subsetting method used in lecture
    # make a blank canvas, with limits that will fit all the data
    with(submetering_long, plot(datetime, value, main = NULL, 
                                type = "n", xlab = "", ylab = "Energy sub metering")) 
    # add data sets one by one 
    with(subset(submetering_long, variable == "Sub_metering_1"), lines(datetime, value, col = "black"))
    with(subset(submetering_long, variable == "Sub_metering_2"), lines(datetime, value, col = "red"))
    with(subset(submetering_long, variable == "Sub_metering_3"), lines(datetime, value, col = "blue"))
    # include manual legend
    legend("topright", lty = 1, col = c("black", "red","blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

    # save it to a PNG file with a width of 480 pixels and a height of 480 pixels (png default size)
    png(file = "plot3.png")
    with(submetering_long, plot(datetime, value, main = NULL, 
                                type = "n", xlab = "", ylab = "Energy sub metering"))  
    with(subset(submetering_long, variable == "Sub_metering_1"), lines(datetime, value, col = "black"))
    with(subset(submetering_long, variable == "Sub_metering_2"), lines(datetime, value, col = "red"))
    with(subset(submetering_long, variable == "Sub_metering_3"), lines(datetime, value, col = "blue"))
    legend("topright", lty = 1, col = c("black", "red","blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()

