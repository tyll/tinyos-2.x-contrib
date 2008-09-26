library("DBI")
library("RMySQL")
library("R.utils")


##setup the device
##pdf()
##png2("gen/incoming.png", width=1200, height=800, res=144, type="png256")
pdf("gen/Network/incoming.pdf", width=6, height=4, pointsize=12);
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



#build queries
nodereps <- rep(nodes$node,1,each=length(bs$baseID))

#sqls <- paste("select email_time, count(*) from RT_STATE where datasrc=",nodereps," AND baseID=\"",bs$baseID,"\" AND email_time >= \"",bs$start_date,"\" AND email_time <= \"",bs$end_date,"\";",sep="")

#sqlall <- "SELECT email_time, sum(packets) from BASESTATION GROUP BY email_time ORDER BY email_time;"
sqlall <- "SELECT DATE_FORMAT(email_time,'%Y-%m-%d') as Date, sum(packets) from BASESTATION GROUP BY Date ORDER BY Date;"

resall <- dbGetQuery(con,sqlall)
	
#ts2 <- strptime(resall[[1]], "%Y-%m-%d %H:%M:%S") 
ts2 <- strptime(resall[[1]], "%Y-%m-%d") 
ct2 <- resall[[2]]


tables <- c("GPS","CONN","RT_STATE","RT_PATH")
#sqls <- paste("select b.email_time, b.packets, count(g.datasrc) from BASESTATION as b LEFT JOIN ",tables," as g ON b.email_time=g.email_time GROUP BY email_time ORDER BY email_time;", sep="") 
sqls <- paste("select DATE_FORMAT(b.email_time,'%Y-%m-%d') as Date, b.packets, count(g.datasrc) from BASESTATION as b LEFT JOIN ",tables," as g ON b.email_time=g.email_time GROUP BY Date ORDER BY Date;", sep="") 

#sqls <- "select email_time, count(*) from RT_STATE group by YEAR(email_time), MONTH(email_time), #DAY(email_time), HOUR(email_time);"

sqls

ct <- rep.int(0, length(ct2))

for (i in 1:length(sqls))
{
	res <- dbGetQuery(con,sqls[[i]])
	
	#plot(local_time, volts, col=nodereps[[i]]) 
	#length(res)
	
	#ts <- strptime(res[[1]], "%Y-%m-%d %H:%M:%S") 
	ct <- ct + res[[3]]
}


plot(ts2, ct2, ylab="Packets Delivered (Total & New)", yaxs="i", type="h", lwd=2, ljoin=0, lend=0, col="red", ylim=c(0,max(c(max(ct),max(ct2))) * 1.2))
#plot(ct, ts, type="h", pch=20)

lines(ts2, ct, yaxs="i", type="h", lwd=2, ljoin=0, lend=0, col="blue");

#res <- dbGetQuery(con, sql);
#results <- c(results, res)
##close png device
dev.off()

