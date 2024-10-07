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


public class ClientHandler extends Thread {

	private Socket s;
	private BufferedReader in;
	private PrintWriter out;
	private List<Socket> sockets_list;
	private List<GruppoChat> gruppi_list;
	private Admin admin;
	

	public ClientHandler(Socket s, List<Socket> sockets_list, List<GruppoChat> gruppi_list, boolean op) {
		this.s = s;
		this.sockets_list = sockets_list;
		this.gruppi_list = gruppi_list;
		if(op) {
			admin = new Admin();
		}
		else
		{
			admin = null;
		}
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
	
	private boolean checkInput(String tmp, String added) {
		
		if(added.equals("")) {
			return false;
		}
		
		String x[] = added.trim().split(",");
		
		for(int i = 0; i < x.length; i++) {
			if(tmp.equals(x[i])) {
				return true;
			}
		}
		
		return false;
		
	}

	private List<Socket> createListGroup(){

		String tmp = "";
		String added = "";
		List<Socket> clients_toAdd = new ArrayList<Socket>();

		try{
					
					clients_toAdd.add(s);
					

					while(!((tmp = in.readLine()).equalsIgnoreCase("/exit"))) {
						
						
						if(!checkInput(tmp, added)) {
							try {
								
								clients_toAdd.add(sockets_list.get(Integer.parseInt(tmp)));
								added += tmp + ",";
								
								
							} catch(NumberFormatException e) {
								
								out.println("Errore, carattere inserito non valido");
							}
							
							
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
			if(admin != null) {
				out.println("Sei l'admin! (primo utente collegato)");
			}
			
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
					
					clientMessage = getListNewGroup();
					
					clientMessage += "\nche utenti vuoi aggiungere (numeri), per uscire digita '/exit'";
					
					out.println(clientMessage);
					
					clientMessage = "";

					gruppi_list.add(new GruppoChat(createListGroup(), nome_gruppo));
					
					out.println("Gruppo " + "'" + nome_gruppo + "'" + " creato");

					
				}
				
				else if(clientMessage.equalsIgnoreCase("/getGroups")) {
					out.println(getGroups());
				}
				
				else if(clientMessage.equalsIgnoreCase("/isAdmin")) {
					if(admin != null) {
						out.println(admin.seiAdmin());
					}
					else
					{
						out.println("Non sei un admin!!");
					}
				}

				
				else{

					out.println("A chi vuoi inviarlo? (/exit per uscire, digitare di volta in volta i destinatari)");
					
					String temp = "broadcast\n" + getList();
					
					temp += "\n" + checkGruppo();
					
					out.println(temp);
					
					String toSend = clientMessage;
					
					while(!((clientMessage = in.readLine()).equalsIgnoreCase("/exit"))) {
						
						if(clientMessage.equalsIgnoreCase("broadcast")) {
							broadcast(toSend);
						}
						else
						{
							sendMessage(clientMessage, toSend);
						}
						
						
						
					}
					

				}
			}
			
		} catch(IOException e) {
			
			e.printStackTrace();
		}
		
		
		
		
	}

	private String getListNewGroup(){

		String tmp = "";

		for(int i=0; i<sockets_list.size(); i++){

			if(!checkSockets(sockets_list.get(i))){

				tmp += i + " -> " + sockets_list.get(i).getInetAddress().getHostName() + "\n";
			}
		}

		return tmp;
	}
	
	private void broadcast(String toSend) {
		
		for(Socket x : sockets_list) {
			
			if(x != s) {
				try {
					PrintWriter message = new PrintWriter(x.getOutputStream(), true);
					message.println(toSend);
				}
				catch(IOException e) {
					e.printStackTrace();
				}
			}
		}
		
	}
	
	private String getGroups() {
		
		int n_gruppi = 0;

		String tmp = "";

		for(GruppoChat x : gruppi_list) {

			if(x.findClient(s)) {
				tmp += (n_gruppi++) + " -> " + x.getNomeGruppo() + "\n";
				tmp += x.getList() + "\n";
				
			}
						
		}

		return tmp;
		
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
