package server_multithread;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.Scanner;

public class ServerThread extends Thread {
	
	Socket s = null;
	

	public ServerThread(Socket s) {
		
		this.s = s;
	}
	
	
	public void run() {
		
		try {
			
			
			DataInputStream din = null;
			
			DataOutputStream dout = null;
			
			din=new DataInputStream(s.getInputStream());
			dout=new DataOutputStream(s.getOutputStream());      
			String str=""; 
			System.out.println("Connesso a un client");    
			while(true){  
				
				str=din.readUTF();
				
				if(!str.equals("stop")) {
					
					System.out.println("Risposta dal client " + s.getInetAddress().getHostName() + " client: " + str);  
				}
				
				else {
					
					dout.writeUTF("Server terminato");
					din.close();  
					s.close();  
					
				}
				  
			}
			
			
		} catch(SocketException e) {
			
			System.out.println("Client disconnesso");
			
		} catch(EOFException e) {
			
			System.out.println("Client disconnesso");
		}
		
		catch(IOException e) {
			
			e.printStackTrace();
		}
		
		
	}
}