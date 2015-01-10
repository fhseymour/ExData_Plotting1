# Coursera John's Hopkins Exploratory Data Analysis Online Class
# Course Project 1, code for generating Plot 4
# Combination of 4 plots for Feb 1 and 2, 2007
# FHS Jan 9, 2015

############################################################
# Loading Data
# On first run, loads the big all data file and creates 
# Feb1 to Feb2 subset file for any subsequent runs.
############################################################

subsetDataFileName <- "data/subset_household_power_consumption.txt"
if (!file.exists(subsetDataFileName)) {    
    # no subset file, so read in all data (large file)
    allDataFileName <- "data/household_power_consumption.txt"
    allData <- read.table(allDataFileName, header=T, sep=";")
    
    # Select subset data for plotting from Feb 1 and Feb 2 2007
    allData$Date <- as.Date(allData$Date, "%d/%m/%Y") # convert text to date format
    subsetData <- allData[allData$Date == "2007-2-1" | allData$Date == "2007-2-2",]
    # coerce datatypes from Factor to char to numeric for plotting
    subsetData$Global_active_power <- as.numeric(as.character(subsetData$Global_active_power))
    subsetData$Global_reactive_power <- as.numeric(as.character(subsetData$Global_reactive_power))
    subsetData$Voltage <- as.numeric(as.character(subsetData$Voltage))
    subsetData$Sub_metering_1 <- as.numeric(as.character(subsetData$Sub_metering_1))
    subsetData$Sub_metering_2 <- as.numeric(as.character(subsetData$Sub_metering_2))
    subsetData$Sub_metering_3 <- as.numeric(as.character(subsetData$Sub_metering_3))    
    
    # write file of subset plotting data for future use
    write.table(subsetData,file=subsetDataFileName,
                quote=F, sep=";",
                row.names=F,col.names=T)
} else {
    # Feb 1 and Feb 2 subset file already exists, simply read it in
    subsetData <- read.table(subsetDataFileName, header=T, sep=";")
}

############################################################
# Create combination of 4 graphs  (Plot4) 
# and save to PNG file
############################################################

# concatenate date & time in single string
subsetData$Datetime <- paste(as.character(subsetData$Date), as.character(subsetData$Time), sep=" ")
# convert date & time to POSIXlt structure
subsetData$Datetime <- strptime(subsetData$Datetime, "%Y-%m-%d %H:%M:%S")

par(mfrow=c(2,2)) # (2,2) graphs

plot(subsetData$Datetime, subsetData$Global_active_power, type = "l",
     xlab ="", ylab="Global Active Power")

plot(subsetData$Datetime, subsetData$Voltage, type = "l",
     xlab ="datetime", ylab="Voltage")

plot(subsetData$Datetime, subsetData$Sub_metering_1, type = "n",
     xlab ="", ylab="Energy sub metering")
lines(subsetData$Datetime, subsetData$Sub_metering_1, col="black")
lines(subsetData$Datetime, subsetData$Sub_metering_2, col="red")
lines(subsetData$Datetime, subsetData$Sub_metering_3, col="blue")
# for 480x480 pixel png file to scale properly needed to be explicit with legend x,y location
legend(x=1170370000, y=40, lty=1, col=c("black","red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n", cex=0.8)

plot(subsetData$Datetime, subsetData$Global_reactive_power, type = "l",
     xlab ="datetime", ylab="Global_reactive_power")

pngFileName <- "plots/plot4.png"
dev.copy(png, file=pngFileName) # copy plot to a png file
dev.off() # close png file device