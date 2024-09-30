import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class GruppoChat {
	
	
	private List<Socket> clients = new ArrayList<Socket>();
	private String nomeGruppo;
	
	

	public GruppoChat(List<Socket> clients, String nomeGruppo) {
		
		this.clients = clients;
		this.nomeGruppo = nomeGruppo;
	}
	
	public void mandaMsg(String msg_client, Socket client) {
		
		for(Socket x : clients) {
			
			if(!checkSockets(x, client)) {
				
				 PrintWriter broadcast_stream;
				 
				try {
					
					broadcast_stream = new PrintWriter(x.getOutputStream(), true);
				
					broadcast_stream.println(msg_client);
					
				} catch (IOException e) {
					
					e.printStackTrace();
				}
				
				 
			}
		}
		
		
	}
	
	public String getNomeGruppo() {
		
		return nomeGruppo;
	}

	public void setNomeGruppo(String nomeGruppo) {
		
		this.nomeGruppo = nomeGruppo;
	}
	
	
	

	private boolean checkSockets(Socket temp, Socket client) {
		
		if(temp == client) 
			return true;
		else
			return false;
		
	}
	
	public String aggiungiClient(Socket toAdd) {
		
		
		for(Socket s : clients) {
			
			if(s == clients) {
				
				return "utente già presente";
				
			}
		}
		
		clients.add(toAdd);
		
		return "utente " + toAdd.getInetAddress().getHostName() + " aggiunto";
		
	}
	
	public String rimuoviClient(Socket toRemove) {
		
		
		for(Socket s : clients) {
			
			if(s == clients) {
				
				clients.remove(toRemove);
				
				return "utente " + toRemove.getInetAddress().getHostName() + " rimosso";
				
				
			}
		}
		
		return "utente non trovato";
		
		
	}
	
	public boolean findClient(Socket client) {
		
		for(Socket x : clients) {
			
			if(x == client) 
				return true;
			
		}
		
		return false;
		
	}
	
	
	
	
	

}
