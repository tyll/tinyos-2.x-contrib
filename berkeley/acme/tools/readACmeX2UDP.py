
import socket
import ACmeX2Report
import re
import sys

#import MySQLdb
#import tinyos.message.Message

#host = '2001:470:1f04:5b8::64'
#host = '2001:638:709:1234:0:ff:fe00:64'
host = ''
port = 7001

if __name__ == '__main__':
    
    # conn2 = MySQLdb.connect (host = "128.32.37.210",
    #                         user = "acme",
    #                         db = "acme2",
    #                         passwd = "410soda")

    # cursor2 = conn2.cursor();

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
                

            print rpt

            
#            print "moteid=%d, parent=%d, totalEnergy=%ld" % (moteid, parent, totalEnergy)

#            print energy
#            print parent
#            print totalEnergy


            # insert2 = "INSERT INTO energy VALUES ("
            # insert2 += str(moteid) + "," + "NOW()," + str(seq) + ","
            # insert2 += str(power) + "," + str(averagePower) + ","
            # insert2 += str(maxPower) + "," + str(minPower) + ","
            # insert2 += str(energy) + "," + str(totalEnergy)
            # insert2 += ");"

            # print insert2
            # try:
            #     cursor2.execute(insert2)
            # except cursor2.Error, e:
            #     # print "Data duplicate detected"
            #     print "Error %d: %s" % (e.args[0], e.args[1])

            # debug = "INSERT INTO debug VALUES ("
            # debug += str(moteid) + "," + "NOW()," + str(seq) + ","
            # debug += str(parent) + "," + str(parent_metric) + ","
            # debug += str(parent_etx) + "," + str(hop_limit) + ","
            # debug += "0);"

            # print debug

            # try:
            #   cursor2.execute(debug)
            # except cursor2.Error, e:
            #     # print "Data duplicate detected"
            #     print "Error %d: %s" % (e.args[0], e.args[1])

    conn.close()

