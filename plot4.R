# Exploratory Data Analysis programming assignment 1
# part 4
# R code for contructing plot 4: 4 panel figure with plots of (clockwise from left corner):
# global active power, voltage, global reactive power, and the three sub metering values over time

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
    
# prep data for plots
    # generate a new variable datetime that combines both Date and Time in POSIXlt format
    # paste Date and Time together into a single character string called Datetimestring
    # (I tried converting them first, but this is easier)
    twofebdays$Datetimestring <- paste(as.character(twofebdays$Date), as.character(twofebdays$Time))
    str(twofebdays)
    # convert date and time to POSIXlt using strptime()
    # date format dd/mm/yyyy = %d/%m/%Y
    # time format hh:mm:ss = %H:%M:%S
    twofebdays$datetime <- strptime(twofebdays$Datetimestring, format = "%d/%m/%Y %H:%M:%S")
    str(twofebdays)
    # convert to POSIXct for subsequent melting (this is less coding than doing both seperately as in fig 3)
    twofebdays$datetime <- as.POSIXct(twofebdays$datetime)
    
    # data for the submetering plot:
    # melt the data, keeping datetime, and melting the Sub_metering values
    library(reshape)
    submetering_long <- melt(twofebdays, id = c("datetime"), 
                             measure = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
# figure 4: 
    # (fyi, if using R studio, make sure your plotting window is big enough, otherwise you'll get errors about margins being too big)
    par(mfrow = c(2,2)) # set for 2 rows and 2 columns
    # global active power: column1, row 1
    plot(twofebdays$datetime, twofebdays$Global_active_power, 
         type = "l",
         main = NULL, 
         ylab = "Global Active Power",
         xlab = "")
    
    # voltage: column 2, row 1
    plot(twofebdays$datetime, twofebdays$Voltage, 
         type = "l",
         main = NULL,
         ylab = "Voltage",
         xlab = "datetime")
    
    # submetering: column 1, row 2
    # make a blank canvas, with limits that will fit all the data
    with(submetering_long, plot(datetime, value, main = NULL, 
                                type = "n", xlab = "", ylab = "Energy sub metering")) 
    # add data sets one by one 
    with(subset(submetering_long, variable == "Sub_metering_1"), lines(datetime, value, col = "black"))
    with(subset(submetering_long, variable == "Sub_metering_2"), lines(datetime, value, col = "red"))
    with(subset(submetering_long, variable == "Sub_metering_3"), lines(datetime, value, col = "blue"))
    # include manual legend
    legend("topright", bty = "n", lty = 1, col = c("black", "red","blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # global reactive power: column 2, row 2
    plot(twofebdays$datetime, twofebdays$Global_reactive_power, 
         type = "l",
         main = NULL,
         ylab = "Global_reactive_power",
         xlab = "datetime")
    

# save it to a PNG file with a width of 480 pixels and a height of 480 pixels (png default size)
    
    png(file = "plot4.png")
    par(mfrow = c(2,2))
    # global active power: column1, row 1
    plot(twofebdays$datetime, twofebdays$Global_active_power, 
         type = "l",
         main = NULL, 
         ylab = "Global Active Power",
         xlab = "")
    
    # voltage: column 2, row 1
    plot(twofebdays$datetime, twofebdays$Voltage, 
         type = "l",
         main = NULL,
         ylab = "Voltage",
         xlab = "datetime")
    
    # submetering: column 1, row 2
    # make a blank canvas, with limits that will fit all the data
    with(submetering_long, plot(datetime, value, main = NULL, 
                                type = "n", xlab = "", ylab = "Energy sub metering")) 
    # add data sets one by one 
    with(subset(submetering_long, variable == "Sub_metering_1"), lines(datetime, value, col = "black"))
    with(subset(submetering_long, variable == "Sub_metering_2"), lines(datetime, value, col = "red"))
    with(subset(submetering_long, variable == "Sub_metering_3"), lines(datetime, value, col = "blue"))
    # include manual legend
    legend("topright", bty = "n", lty = 1, col = c("black", "red","blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # global reactive power: column 2, row 2
    plot(twofebdays$datetime, twofebdays$Global_reactive_power, 
         type = "l",
         main = NULL,
         ylab = "Global_reactive_power",
         xlab = "datetime")
    dev.off()

