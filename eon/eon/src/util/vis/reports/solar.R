library("DBI")
library("RMySQL")


##setup the device
##pdf()
#png("testplot.png", width=480, height=360, pointsize=12, bg="white", res=NA)
pdf("gen/Runtime/solar.pdf", width=6, height=4, pointsize=12);
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


bs

nodes


#build queries
nodereps <- rep(nodes$node,1,each=length(bs$baseID))
#nodereps <- rep(c(8,11),1,each=length(bs$baseID))

##select datasrc,local_stamp, energy_in from RT_STATE where timeinvalid=0 order by datasrc,local_stamp;

trsql = sqls <- "select min(local_stamp), max(local_stamp) from RT_STATE where timeinvalid=0 order by local_stamp;"

trres <- dbGetQuery(con,trsql)
trmax <- strptime(trres[[2]][[1]], "%Y-%m-%d %H:%M:%S")
trmin <- strptime(trres[[1]][[1]], "%Y-%m-%d %H:%M:%S")

sqls <- paste("select * from RT_STATE where timeinvalid=0 AND datasrc=",nodereps,
		" AND baseID=\"",bs$baseID,"\" AND email_time >= \"",
		bs$start_date,"\" AND email_time <= \"",bs$end_date,"\" order by local_stamp;",sep="")

sqls
##plot.new()
numplots <- 0
energies <- list()
times <- list()
srcs <- list()
for (i in 1:length(sqls))
{
	res <- dbGetQuery(con,sqls[[i]])
	
	#print(sqls[[i]])
	if (length(res) == 0)
	{
		print("NO RESULTS");
	} else {
		#print(paste("Node:",res$datasrc[1],"returned",length(res[[i]]),"results"))
		#print(length(res[[1]]))
	}
	
	
	if (length(res$local_stamp) > 2)
	{
		local_time <- as.POSIXct(strptime(res$local_stamp, "%Y-%m-%d %H:%M:%S")) 
		email_time <- as.POSIXct(strptime(res$email_time, "%Y-%m-%d %H:%M:%S"))
		
		volts <- res$batt_volts
		energy_in <- res$energy_in
		print(paste("energy_in contains",length(energy_in),"results."))
		temp <- res$temperature / 10
		
		pts <-c()
		tms<-c()
		
		
		for (j in 1:(length(energy_in)-1))
		{
			
			dtime <- difftime(as.POSIXlt(local_time[[j+1]]), as.POSIXlt(local_time[[j]]), units=c("hours"))[[1]];
			denergy <- energy_in[[j+1]] - energy_in[[j]];
			
			#print(paste("dtime =",dtime," denergy =",denergy))
			if (dtime > 0 && dtime < 6)
			{
				if (trunc(dtime) <= 0)
				{
					tincr <- dtime * 3600
				} else {
					tincr <- (dtime / trunc(dtime)) * 3600;
				}
				tmpt <- seq(local_time[[j]], local_time[[j+1]], paste(tincr,"sec"))
				tmpt <- tmpt[2:length(tmpt)]
				tmpe <- rep(denergy/(length(tmpt)), length(tmpt))
				
				if (length(tms) == 0)
				{
					tms <- tmpt
					pts <- tmpe
					
				} else {
					tms <- c(tms, tmpt)
					pts <- c(pts, tmpe)
				}
				
			} else {
				if (length(tms) > 0)
				{
					
					energies <- c(energies, list(pts))
					times <- c(times, list(tms))
					srcs <- c(srcs, list(nodereps[[i]]))
					numplots <- numplots+1
					tms <- c()
					pts <- c()
				}
			}
			
		}
		if (length(tms) > 0)
		{
			energies <- c(energies, list(pts))
			times <- c(times, list(tms))
			srcs <- c(srcs, list(nodereps[[i]]))
			numplots <- numplots+1
			tms <- c()
			pts <- c()
		}
	}
}

# get ranges
emax <- 0
tmax <- NULL
tmin <- NULL
for (i in 1:length(energies))
{
	if (length(tmax) == 0)
	{	
		tmax <- max(times[[i]])
		tmin <- min(times[[i]])
	} else {
		tmax <- max(tmax, times[[i]])
		tmin <- min(tmin, times[[i]])
	}
	emax <- max(emax,max((energies[[i]]/3600)))
}


for (i in 1:length(energies))
{
	ts <- as.POSIXlt(times[[i]])
				
	if (i == 1)
	{
		plot(ts,(energies[[i]]/3600), type='l',col=srcs[[i]], ylab='Solar Power (mW)',xlim=range(tmin,tmax), ylim=range(0,emax), pch=20)
	} else {
		lines(ts,(energies[[i]]/3600), col=srcs[[i]], pch=20)
	}
}

#res <- dbGetQuery(con, sql);
#results <- c(results, res)
##close png device
dev.off()