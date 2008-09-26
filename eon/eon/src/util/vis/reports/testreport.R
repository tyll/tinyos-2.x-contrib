library("DBI")
library("RMySQL")


##setup the device
##pdf()
#png("testplot.png", width=480, height=360, pointsize=12, bg="white", res=NA)
pdf("gen/incoming.pdf", width=6, height=4, pointsize=12);
oldpar <- par(font.lab=2,
		mai = c(.6,1.2,.4,.4))


#connect to the database
con <- dbConnect("MySQL", username="turtle", password="hardshell", dbname="snapper_turtles", host="diesel.cs.umass.edu")

#get the data
dep <- "Miss"
sql <- paste("SELECT * FROM DEPLOYMENT WHERE baseID IS NOT NULL AND depID IN (\"",dep,"\");",sep="")
bs <- dbGetQuery(con, sql);

sql <- paste("SELECT distinct node FROM DEPLOYMENT WHERE node IS NOT NULL AND depID IN (\"",dep,"\");",sep="")
nodes <- dbGetQuery(con, sql);


#res <- dbGetQuery(con, "SELECT local_stamp, temperature FROM RT_STATE;");
bs

nodes


#build queries
nodereps <- rep(nodes$node,1,each=length(bs$baseID))

sqls <- paste("select * from RT_STATE where datasrc=",nodereps,
		" AND baseID=\"",bs$baseID,"\" AND email_time >= \"",
		bs$start_date,"\" AND email_time <= \"",bs$end_date,"\";",sep="")

##plot.new()
for (i in 1:length(sqls))
{
	res <- dbGetQuery(con,sqls[[i]])
	
	#plot(local_time, volts, col=nodereps[[i]]) 
	length(res)
	
	if (length(res$local_stamp) > 1)
	{
		local_time <- strptime(res$local_stamp, "%Y-%m-%d %H:%M:%S") 
		email_time <- strptime(res$email_time, "%Y-%m-%d %H:%M:%S") 
		volts <- res$batt_volts
		temp <- res$temperature / 10
		if (i == 1)
		{
			plot(email_time, temp, col=nodereps[[i]], pch=20)
		} else {
			points(email_time, temp, col=nodereps[[i]], pch=20)
		}
	}
}

#res <- dbGetQuery(con, sql);
#results <- c(results, res)
##close png device
dev.off()