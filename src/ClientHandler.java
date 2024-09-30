import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

//versione fatta a scuola (Desktop)

public class ClientHandler extends Thread {

	private Socket s;
	private BufferedReader in;
	private PrintWriter out;
	private List<Socket> sockets_list;
	private List<GruppoChat> gruppi_list;
	
	

	public ClientHandler(Socket s, List<Socket> sockets_list, List<GruppoChat> gruppi_list) {
		this.s = s;
		this.sockets_list = sockets_list;
		this.gruppi_list = gruppi_list;
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

	private boolean checkSockets(Socket temp) {
		
		if(temp == s) 
			return true;
		else
			return false;
		
	}
	
	private String getList(){

		int n_client = 0;

		String tmp = "";

		for(Socket x : sockets_list) {

			if(!checkSockets(x)){

				tmp += (n_client++) + " -> " + x.getInetAddress().getHostName() + "\n";
			}
						
		}

		return tmp;
	}

	private List<Socket> createListGroup(){

		String tmp = "";
		List<Socket> clients_toAdd = new ArrayList<Socket>();

		try{
					
					clients_toAdd.add(s);

					while(!((tmp = in.readLine()).equalsIgnoreCase("/exit"))) {
						
						
						try {
							
							clients_toAdd.add(sockets_list.get(Integer.parseInt(tmp)));
							
							
						} catch(NumberFormatException e) {
							
							out.println("Errore, carattere inserito non valido");
						}
						
					}

		} catch(IOException e){

			e.printStackTrace();
		}

		

					return clients_toAdd;
					
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
	
	private void updateList() throws IOException {
		
		for(Socket x : sockets_list) {
			 PrintWriter broadcast_stream = new PrintWriter(x.getOutputStream(), true);
			 String tmp = "List,";
			 for(Socket y : sockets_list) {
					if(y != x) {
						tmp += y.getInetAddress().getHostName() + ",";
					}
				}
			 broadcast_stream.println(tmp);
			 //broadcast_stream.println(clientMessage);
		}
	}
	
	@SuppressWarnings("deprecation")
	private void clientTest() {
		
		try {
			
			updateList();	
			
			System.out.println("In attesa di messaggi dal client...");

			String clientMessage;
			
			
			// Legge messaggi dal client
			while ((clientMessage = in.readLine()) != null) {
				System.out.println("Messaggio dal client " + s.getInetAddress().getHostName() + ": " + clientMessage);

				// Controlla se il client vuole terminare la connessione
				if (clientMessage.equalsIgnoreCase("exit")) {
					
					System.out.println("Il client ha terminato la connessione.");
					out.println("Chiuso");
					break; // Uscire dal ciclo chiude la connessione
				}
				
				else if (clientMessage.equalsIgnoreCase("/getList")) {
					
					out.println(getList());
	
				}
				
				else if(clientMessage.equalsIgnoreCase("/newGroup")) {
					
					clientMessage = "";
					
					out.println("Inserisci il nome del gruppo");
					
					while(((clientMessage = in.readLine()).trim().equals(""))) {}
					
					String nome_gruppo = clientMessage;
					
					clientMessage = getList();
					
					clientMessage += "\nche utenti vuoi aggiungere (numeri), per uscire digita '/exit'";
					
					out.println(clientMessage);
					
					clientMessage = "";

					gruppi_list.add(new GruppoChat(createListGroup(), nome_gruppo));
					
					out.println("Gruppo " + "'" + nome_gruppo + "'" + " creato");

					
				}

				
				else{

					out.println("A chi vuoi inviarlo?");
					
					String temp = getList();
					
					temp += "\n" + checkGruppo();
					
					out.println(temp);
					
					String toSend = clientMessage;
					
					while(!((clientMessage = in.readLine()).equalsIgnoreCase("/exit"))) {
						
						sendMessage(clientMessage, toSend);
						
					}
					

				}
			}
			
		} catch(IOException e) {
			
			e.printStackTrace();
		}
		
		
		
		
	}
	
	
	private void sendMessage(String nome, String toSend) {
		
		for(Socket x : sockets_list) {
			if(nome.equalsIgnoreCase(x.getInetAddress().getHostName())) {
				try {
					PrintWriter message = new PrintWriter(x.getOutputStream(), true);
					message.println(toSend);
				}
				catch(IOException e) {
					e.printStackTrace();
				}
			}
		}

		for(GruppoChat y : gruppi_list) {
			if(nome.equalsIgnoreCase(y.getNomeGruppo())) {

				y.mandaMsg(toSend, s);

			}
		}
		
	}
	
	private String checkGruppo() {
		
		String st = "";
		
		for(GruppoChat gc : gruppi_list) {
			
			if(gc.findClient(s))
				st += gc.getNomeGruppo() + "\n"; 
				
			
		}
		
		return st;
		
	}
}
