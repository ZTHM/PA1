

library(data.table)
library(plyr)
library(ggplot2)

url <-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

download.file(url,destfile = "Dataset.zip")
unzip("Dataset.zip")

print('Unzipping data....')

NEI <- readRDS("summarySCC_PM25.rds")
Scc <- readRDS("Source_Classification_Code.rds")
SCC.motor <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.identifiers <- as.character(SCC.motor$SCC)
NEI$SCC <- as.character(NEI$SCC)
NEIMotor <- NEI[NEI$SCC %in% SCC.identifiers, ]
AggregData_Motor_Balti <- NEIMotor[which(NEIMotor$fips == "24510"), ]
AggregDataBalti_Motor <- with(AggregData_Motor_Balti, aggregate(Emissions, by = list(year), 
                                                         sum))


SCC.motor <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.identifiers <- as.character(SCC.motor$SCC)


NEI$SCC <- as.character(NEI$SCC)
NEIMotor <- NEI[NEI$SCC %in% SCC.identifiers, ]

AggregData_Motor_Balti <- NEIMotor[which(NEIMotor$fips == "24510"), ]
AggregData_Motor_LA <- NEIMotor[which(NEIMotor$fips == "06037"), ]

AggregDataBalti_Motor <- with(AggregData_Motor_Balti, aggregate(Emissions, by = list(year), 
                                                         sum))
AggregDataBalti_Motor$group <- rep("Baltimore County", length(AggregDataBalti_Motor[, 
                                                                                    1]))


AggregDataLosAng_Motor <- with(AggregData_Motor_LA, aggregate(Emissions, by = list(year), 
                                                         sum))
AggregDataLosAng_Motor$group <- rep("Los Angeles County", length(AggregDataLosAng_Motor[, 
                                                                                      1]))

AggregData_Motor <- rbind(AggregDataLosAng_Motor, AggregDataBalti_Motor)
AggregData_Motor$group <- as.factor(AggregData_Motor$group)

colnames(AggregData_Motor) <- c("Year", "Emissions", "Group")

qplot(Year, Emissions, data = AggregData_Motor, group = Group, color = Group, 
      geom = c("point", "line"), ylab = expression("Total Emissions, PM"[2.5]), 
      xlab = "Year", main = "Comparison of Total Emissions by County")
## House keeping
remove(AggregDataBaltimoreMotor,NEI,Scc)

print('All done!') 


