# Set locale for English Date names

Sys.setlocale("LC_TIME", "C")


# Download and unzip data if necessary

if (!file.exists("household_power_consumption.txt")) {
    
    if (!file.exists("household_power_consumption.zip")){
        
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url = fileUrl, destfile = "household_power_consumption.zip")
        
    }
    
    unzip(zipfile = "household_power_consumption.zip")
    
}


# Read the date into a data frame

dt <- read.table(file = "household_power_consumption.txt", header = TRUE, sep = ";")


# Take only the relevant data

dt <- subset(dt, as.Date(Date, format = "%d/%m/%Y") >= as.Date("2007-02-01") &
                 as.Date(Date, format = "%d/%m/%Y") <= as.Date("2007-02-02"))


# Create DateTime column by merging the Date and Time columns,
# and then converting to "POSIXlt"

dt$DateTime <- with(dt, paste(Date, Time, sep = " "))
dt$DateTime <- strptime(dt$DateTime, format = "%d/%m/%Y %H:%M:%S")


# Set "?" values to NA

to_NA <- function(x){
    x[x == "?"] <- NA
    x
}

dt[,3:8] <- lapply(dt[,3:8], to_NA)


# Convert factor to numeric

dt[,3:8] <- lapply(dt[,3:8], function(x) as.numeric(levels(x))[x])


# Plot

png(filename = "plot2.png", width = 480, height = 480, units = "px")

with(dt, plot(DateTime, Global_active_power, type = "l",
              xlab = NA, ylab = "Global Active Power (kilowatts)"))

dev.off()