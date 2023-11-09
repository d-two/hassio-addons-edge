#!/usr/bin/env python3
import socket, paramiko, threading
from datetime import datetime

class SSH_Server(paramiko.ServerInterface):
	def __init__( self, client_addr ):
		self.client_addr = client_addr

	def check_auth_password(self, username, password):
        # Port: {self.client_addr[1]}
		print(f"[{datetime.now()}] Connection: {self.client_addr[0]} User: {username} Password: {password}")
		return paramiko.AUTH_FAILED
	
	def check_auth_publickey(self, username, key):
		return paramiko.AUTH_FAILED
	
def handle_connection(client_sock, server_key, client_addr):
	transport = paramiko.Transport(client_sock)
	transport.add_server_key(server_key)
	ssh = SSH_Server(client_addr)
	transport.start_server(server=ssh)

def main():
	server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	server_sock.bind(('0.0.0.0', 22))
	server_sock.listen(100)
	
	server_key = paramiko.RSAKey.generate(2048)
	
	while True:
		client_sock, client_addr = server_sock.accept()
		t = threading.Thread(target=handle_connection, args=(client_sock, server_key, client_addr))
		t.start()

if __name__ == "__main__":
	main()