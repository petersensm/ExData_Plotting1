# Exploratory Data Analysis programming assignment 1
# part 2
# R code for contructing plot 2: scatter plot of global active power versus time

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

# plot 2: scatter plot of global active power versus time (actually, datetime)
#     # convert date to date format as.Date() and time to postixct ? strptime()
#     # none of this chunk was necessary; better to combine and do in one fell swoop below.
#     tail(twofebdays)
#     twofebdays$dchar <- as.character(twofebdays$Date)
#     # dd/mm/yyyy = %d/%m/%Y
#     twofebdays$date <- as.Date(twofebdays$Date, format = "%d/%m/%Y") # takes factors as is
#     # same, but in POSIXlt format
#     twofebdays$datev2 <- strptime(as.character(twofebdays$Date), format = "%d/%m/%Y")
#     
#     twofebdays$time <- strptime(as.character(twofebdays$Time), format = "%T") #%T = %H:%M:%S or hh:mm:ss
#     # well, that fills the date as now! So it is brobably better to combine date and time from the start
#     str(twofebdays)

    
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
    
    # construct the plot 
    plot(twofebdays$datetime, twofebdays$Global_active_power, 
         type = "l",
         main = NULL, 
         ylab = "Global Active Power (kilowatts)",
         xlab = "")
    # save it to a PNG file with a width of 480 pixels and a height of 480 pixels (png default size)
    png(file = "plot2.png")
    plot(twofebdays$datetime, twofebdays$Global_active_power, 
         type = "l",
         main = NULL, 
         ylab = "Global Active Power (kilowatts)",
         xlab = "")
    dev.off()

