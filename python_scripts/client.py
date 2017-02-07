import socket
import json
import sys

arg = sys.argv[1]
print arg
data = {'command':'cmd', 'state':arg}
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('192.168.2.116', 23335))
s.send(json.dumps(data))
result = json.loads(s.recv(1024))
print result
s.close()

