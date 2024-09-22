package server_multithread;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ServerThread extends Thread {

	private Socket s;
	private BufferedReader in;
	private PrintWriter out;

	public ServerThread(Socket s) {
		this.s = s;
	}

	public void run() {
		try {
			// Crea stream di input e output
			in = new BufferedReader(new InputStreamReader(s.getInputStream()));
			out = new PrintWriter(s.getOutputStream(), true);

			
			clientTest();
			
			
			

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void closeConnection() {
		
		try {
			
			// Chiude la connessione
			in.close();
			out.close();
			s.close();
			System.exit(0);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
	}
	
	private void clientTest() {
		
		try {
			
			System.out.println("In attesa di messaggi dal client...");

			String clientMessage;
			// Legge messaggi dal client
			while ((clientMessage = in.readLine()) != null) {
				System.out.println("Messaggio dal client: " + clientMessage);

				// Controlla se il client vuole terminare la connessione
				if (clientMessage.equalsIgnoreCase("exit")) {
					System.out.println("Il client ha terminato la connessione.");
					out.println("Chiuso");
					break; // Uscire dal ciclo chiude la connessione
				}

				// Risponde al client
				out.println("Server ha ricevuto il messaggio: " + clientMessage);
			}
			
		} catch(IOException e) {
			
			e.printStackTrace();
		}
		
		
		
		
	}
	private void conChiVuoiParlare(String dispositivo) {
		
		
	}
}
