# import socket 
import socket
# import library untuk threading
import threading
# import OS
import os
# Inisiasi Objek Socket TCP/IP V4
sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

# Bind 
sock.bind(("0.0.0.0",1337))

#Listen permintaan koneksi
sock.listen(100)

data=""
# Fungsi yang akan dieksekusi pada thread baru
def handle_thread(conn):
    try : 
        while True : 
            global data
            # Menerima data dari client
            data = conn.recv(25)
            # Decode jadi string dan ditambah ok didepannya
            data = data.decode("ascii")
            if(data=="restart"):
		os.system("systemctl restart nginx")
            # Kirim balik ke client
            data="restarted"
            conn.send(data.encode("ascii"))
    except(socket.error):
        # Tutup koneksi ketika client menutup koneksi secara paksa
        conn.close()
        print("Connection closed by server1.ku")
    

while True:
    # Terima Permintaan koneksi
    # - Return value : variabel koneksi dan alamat client
    conn, client_addr=sock.accept()
    # Buat thread baru 
    t = threading.Thread(target=handle_thread , args=(conn, ))
    t.start()
