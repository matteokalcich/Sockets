package server_multithread;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class SrvTry {

	@SuppressWarnings("resource")
	public static void main(String[] args) {
		
		ServerSocket ss = null;
		Socket s = null;

		try {
			ss=new ServerSocket(3333);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("Server creato");
		
		//ciclo per controllare sempre se ci sono nuovi tentativi di connessione
		while(true) {
			
			try {
				
				s = ss.accept();
				
			} catch(IOException e) {
				
				e.printStackTrace();
			}
			
			new SrvThread(s).start(); //creo un nuovo thread passando per parametro il socket del client
		}		

	}

}
