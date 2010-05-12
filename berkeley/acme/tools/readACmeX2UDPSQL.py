
import socket
import ACmeX2Report
import re
import sys
import MySQLdb

#host = '2001:470:1f04:5b8::64'
#host = '2001:638:709:1234:0:ff:fe00:64'
host = ''
port = 7001

if __name__ == '__main__':
    
    conn = MySQLdb.connect (host = "128.32.37.210",
                            user = "acme",
                            db = "acmex2",
                            passwd = "410soda")

    cursor = conn.cursor();

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind((host, port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):
            rpt = ACmeX2Report.AcReport(data=data, data_length=len(data))
            #myaddr = str(addr[0]).split(":")
            #moteid = int(myaddr[5],16)
            myaddr = addr[0].split("::")
            moteid = int(myaddr[1],16)
            averagePower = rpt.get_averagePower();
            apparentPower = rpt.get_apparentPower();
            cumulativeEnergy = rpt.get_cumulativeEnergy();
            maxPower = rpt.get_maxPower();
            minPower = rpt.get_minPower();
            seq = rpt.get_seq();

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

            
            print "moteid=%d, seq=%d, averagePower=%d, cumulativeEnergy=%ld" % (moteid, seq, averagePower, cumulativeEnergy)

#            print energy
#            print parent
#            print totalEnergy


            insert = "INSERT INTO energy VALUES ("
            insert += str(moteid) + "," + "NOW()," + str(seq) + ","
            insert += str(averagePower) + "," + str(apparentPower) + ","
            insert += str(maxPower) + "," + str(minPower) + ","
            insert += str(cumulativeEnergy)
            insert += ");"

            print insert
            try:
                cursor.execute(insert)
            except cursor.Error, e:
                # print "Data duplicate detected"
                print "Error %d: %s" % (e.args[0], e.args[1])

            debug = "INSERT INTO debug VALUES ("
            debug += str(moteid) + "," + "NOW()," + str(seq) + ","
            debug += str(parent) + "," + str(parent_metric) + ","
            debug += str(parent_etx) + "," + str(hop_limit) + ","
            debug += "0);"

            print debug

            try:
              cursor.execute(debug)
            except cursor.Error, e:
                # print "Data duplicate detected"
                print "Error %d: %s" % (e.args[0], e.args[1])

    conn.close()

