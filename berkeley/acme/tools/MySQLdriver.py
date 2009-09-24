
import socket
import ACReport
import re
import sys
import MySQLdb

host = ''
port = 7001

if __name__ == '__main__':
    conn = MySQLdb.connect (host = "ip",
                            user = "username",
                            db = "dbname",
                            passwd = "pass")

    cursor = conn.cursor();

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind((host, port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):
            rpt = ACReport.AcReport(data=data, data_length=len(data))
            myaddr = str(addr[0]).split(":")
            print myaddr
            moteid = int(myaddr[2],16)
	    power = rpt.get_power();
	    energy = rpt.get_energy();
	    maxPower = rpt.get_maxPower();
	    minPower = rpt.get_minPower();
            averagePower = rpt.get_averagePower();

            try:
                hop_limit = rpt.get_route_hop_limit();
                parent = rpt.get_route_parent();
                parent_metric = rpt.get_route_parent_metric();
                parent_etx = rpt.get_route_parent_etx();
            except:
                parent = -1
                hop_limit = -1
                parent_metric = -1
                parent_etx = -1
                
#            print rpt

            try:
                totalEnergy = rpt.get_totalEnergy();
            except:
                totalEnergy = -1

            try: 
                seq = rpt.get_seq();
            except:
                seq = 0

            print "moteid=%d, parent=%d, totalEnergy=%ld" % (moteid, parent, totalEnergy)

#            print energy
#            print parent
#            print totalEnergy


            insert = "INSERT INTO energy VALUES ("
            insert += str(moteid) + "," + "NOW()," + str(seq) + ","
            insert += str(power) + "," + str(averagePower) + ","
            insert += str(maxPower) + "," + str(minPower) + ","
            insert += str(energy) + "," + str(totalEnergy)
            insert += ");"

            print insert
            try:
                cursor.execute(insert)
            except cursor.Error, e:
                # print "Data duplicate detected"
                print "Error %d: %s" % (e.args[0], e.args[1])

#	    debug = "INSERT INTO debug VALUES ("
#	    debug += str(moteid) + "," + "NOW()," + str(seq) + ","
#	    debug += str(parent) + "," + str(parent_metric) + ","
#	    debug += str(parent_etx) + "," + str(hop_limit) + ","
#	    debug += "0);"
#
#	    print debug
#	    try:
#		cursor.execute(debug)
#            except cursor2.Error, e:
#                # print "Data duplicate detected"
#                print "Error %d: %s" % (e.args[0], e.args[1])

    conn.close()

