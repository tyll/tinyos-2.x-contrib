library("DBI")
library("RMySQL")
library("R.utils")


##setup the device
##pdf()
##png2("gen/Network/pktdelay.png", width=1200, height=800, res=144, type="png256")
pdf("gen/Network/pktdelay.pdf", width=6, height=4, pointsize=12);
oldpar <- par(font.lab=2,
		mai = c(.6,1.2,.4,.4))


#connect to the database
con <- dbConnect("MySQL", username="turtle", password="hardshell", dbname="snapper_turtles", host="diesel.cs.umass.edu")




#build queries


tables <- c("GPS","CONN","RT_STATE","RT_PATH")
sqls <-  paste("select datasrc, local_stamp, DATEDIFF(email_time,local_stamp) from ",tables,
	" WHERE timeinvalid=0 and DATEDIFF(email_time,local_stamp) < 1000 ORDER BY local_stamp;")


sqls




for (i in 1:length(sqls))
{
	res <- dbGetQuery(con,sqls[[i]])
	
	#plot(local_time, volts, col=nodereps[[i]]) 
	#length(res)
	
	tmp <- as.POSIXct(strptime(res[[2]], "%Y-%m-%d %H:%M:%S"))
	
	if (i == 1)
	{
		ts <- tmp
		ct <- res[[3]]
	} else {
		ts <- c(ts, tmp)
		ct <- c(ct, res[[3]])
	}	
	
}

ts2 <- as.POSIXlt(ts)

plot(ts2, ct, ylab="Packet Delay (Days)", yaxs="i",type="p", pch='.', 
lwd=2, ljoin=0, lend=0, col="red", ylim=c(0,max(ct) * 1.2))




##close png device
dev.off()

