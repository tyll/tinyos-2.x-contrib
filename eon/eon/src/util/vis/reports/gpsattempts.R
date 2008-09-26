library("DBI")
library("RMySQL")
library("R.utils")

##setup the device
##pdf()
#png2("gen/gps.png", width=600, height=400, res=72, pointsize=14,type="png16m")
pdf("gen/Sensors/gps.pdf", width=6, height=4, pointsize=12);
oldpar <- par(font.lab=2,
		mai = c(.6,1.2,.4,.4))

		
#connect to the database
con <- dbConnect("MySQL", username="turtle", password="hardshell", dbname="snapper_turtles", host="diesel.cs.umass.edu")

#get the data

sqlall <- "SELECT  DATE_FORMAT(local_stamp,\"%Y-%m-%d\"), count(*) from GPS WHERE timeinvalid=0 GROUP BY YEAR(local_stamp),MONTH(local_stamp),DAY(local_stamp) ORDER BY local_stamp;" 

sqltry <- "SELECT  DATE_FORMAT(local_stamp,\"%Y-%m-%d\") , count(*) from GPS WHERE timeinvalid=0 AND toofewsats=0 GROUP BY YEAR(local_stamp),MONTH(local_stamp),DAY(local_stamp) ORDER BY local_stamp;" 

sql <- "SELECT  DATE_FORMAT(local_stamp,\"%Y-%m-%d\") , count(*) from GPS WHERE timeinvalid=0 AND gpsvalid=1 GROUP BY YEAR(local_stamp),MONTH(local_stamp),DAY(local_stamp) ORDER BY local_stamp;" 

rall <- dbGetQuery(con, sqlall);
rtry <- dbGetQuery(con, sqltry);
rgps <- dbGetQuery(con, sql);



ts <- strptime(rall[[1]], "%Y-%m-%d") 
ct <- rall[[2]]

ts2 <- strptime(rtry[[1]], "%Y-%m-%d") 
ct2 <- rtry[[2]]

ts3 <- strptime(rgps[[1]], "%Y-%m-%d") 
ct3 <- rgps[[2]]


plot(ts, ct, ylab="GPS (attempts, serious attempts, successes)", yaxs="i", type="h", lwd=3, ljoin=0, lend=0, col="red", ylim=c(0,max(c(max(ct),max(ct2),max(ct3))) * 1.2))


lines(ts2, ct2, yaxs="i", type="h", lwd=3, ljoin=0, lend=0, col="blue");


lines(ts3, ct3, yaxs="i", type="h", lwd=3, ljoin=0, lend=0, col="green2");



#res <- dbGetQuery(con, sql);
#results <- c(results, res)
##close png device
dev.off()

