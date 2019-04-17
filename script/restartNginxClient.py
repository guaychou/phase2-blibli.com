# import socket 
import socket 
# Inisiasi socket
sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
sock2 = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
# Kirim permintaan koneksi ke alamat ip dan port server 
sock.connect(("server2.ku",1337))
sock2.connect(("server3.ku",1337))
# Kirim data ke server
data = "restart"
sock.send(data.encode("ascii"))
sock2.send(data.encode("ascii"))
# Terima balasan dari server
reply = sock.recv(100)
reply2 = sock2.recv(100)
#Decode dan cetak 
reply = reply.decode("ascii")
reply2 = reply2.decode("ascii")
if (reply==reply2):
    print("Success")
