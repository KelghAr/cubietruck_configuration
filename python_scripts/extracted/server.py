import SocketServer
import json
import time
import sqlite3 as lite
import sys

class MyTCPServer(SocketServer.ThreadingTCPServer):
    allow_reuse_address = True

class MyTCPServerHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        try:
            data = json.loads(self.request.recv(1024).strip())

            # process the data, i.e. print it:
	    # print "%s, humidity: %s, temperature: %s" % (time.strftime("%H:%M:%S", time.localtime(data["time"])), data["humidity"], data["temperature"])

	    con = lite.connect('/home/kelghar/mount_point/share/_hide/production.sqlite3')
	    cur = con.cursor()
	    #cur.execute("CREATE TABLE IF NOT EXISTS tmp_sensor(time REAL, humidity TEXT, temperature TEXT)")
	    cur.execute("INSERT INTO weathers VALUES (NULL,?,?,DATETIME('now'), DATETIME('now'))", (data["humidity"], data["temperature"]))
            con.commit()

            # send some 'ok' back
            self.request.sendall(json.dumps({'return':'ok'}))
        except Exception, e:
            print "Exception wile receiving message: ", e

server = MyTCPServer(('192.168.2.42', 23334), MyTCPServerHandler)
server.serve_forever()
