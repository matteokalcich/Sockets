package server_multithread;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.Scanner;

public class SrvThread extends Thread {
	
	Socket s = null;
	

	public SrvThread(Socket s) {
		
		this.s = s;
		
//		try {
//			
//			ss=new ServerSocket(3333); // da fare una volta: mette in ascolto la porta del server 
//			
//		} catch(IOException e) {
//			
//			e.printStackTrace();
//		}
//		
//		System.out.println("Server avviato");
	}
	
	public void create() {
		
//		try {
//			
////			ss=new ServerSocket(3333); // da fare una volta: mette in ascolto la porta del server 
////			System.out.println("Server avviato"); 
//			  
////			din=new DataInputStream(s.getInputStream());
////			dout=new DataOutputStream(s.getOutputStream());      
////			String str=""; 
////			System.out.println("Connesso a un client");    
////			while(true){  
////				
////				str=din.readUTF();
////				
////				if(!str.equals("stop")) {
////					
////					System.out.println("Risposta client: " + str);  
////				}
////				
////				else {
////					
////					dout.writeUTF("Server terminato");
////					din.close();  
////					s.close();  
////					ss.close();
////				}
////				  
////			}
//		} catch(IOException e) {
//			
//			e.printStackTrace();
//		}
		
		
		//din.close();  
		//s.close();  
		//ss.close();
		
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

//	@SuppressWarnings("deprecation")
//	public static void main(String args[]) {
//		
//		try {
//			
//			create();
//			
//		} catch(EOFException e) {
//			
//			System.err.println("ERRORE; CLIENT CHIUSO IN MODO ANOMALO");
//		
//			//new Server();
//		} catch(Exception e) {
//			
//			e.printStackTrace();
//		}
//		
//		 
//	}
}