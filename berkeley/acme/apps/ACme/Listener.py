
import socket
import ACReport
import re
import sys
host = '2001:470:1f04:56d::64'
#host = '2001:638:709:1234:0:ff:fe00:64'
port = 7001

if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind((host, port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = ACReport.AcReport(data=data, data_length=len(data))

            print addr
            print rpt

