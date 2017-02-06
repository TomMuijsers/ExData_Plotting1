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

png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2, 2))

with(dt, {
     plot(DateTime, Global_active_power, type = "l",
          xlab = NA, ylab = "Global Active Power")
     plot(DateTime, Voltage, type = "l")
     plot(DateTime, Sub_metering_1, type = "l",
          xlab = NA, ylab = "Energy sub metering")
     lines(DateTime, Sub_metering_2, type = "l", col = "red")
     lines(DateTime, Sub_metering_3, type = "l", col = "blue")
     legend("topright",
            legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
            lwd=1, col=c("black", "red", "blue"), lty=c(1,1,1), bty = "n")
     plot(DateTime, Global_reactive_power, type = "l")
})

dev.off()