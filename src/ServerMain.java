import java.awt.Checkbox;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class ServerMain {

	@SuppressWarnings("resource")
	public static void main(String[] args) {

		ServerSocket ss = null;
		Socket client_socket = null;
		
		List<Socket> sockets_list = new ArrayList<Socket>();
		
		List<GruppoChat> gruppi_list = new ArrayList<GruppoChat>();
		int clientsOnline = 0;

		try {
			ss = new ServerSocket(3333);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println("Server creato");

		// ciclo per controllare sempre se ci sono nuovi tentativi di connessione
		while (true) {

			try {

				client_socket = ss.accept();
				clientsOnline++;

			} catch (IOException e) {

				e.printStackTrace();
			}
			if(clientsOnline == 1) {
				checkList(sockets_list);
				sockets_list.add(client_socket);
				new ClientHandler(client_socket, sockets_list, gruppi_list, true).start(); // creo un nuovo thread passando per parametro il socket del client
				
			}
			else
			{
				checkList(sockets_list);
				sockets_list.add(client_socket);
				new ClientHandler(client_socket, sockets_list, gruppi_list, false).start(); // creo un nuovo thread passando per parametro il socket del client
				
			}
			
		}

	}
	
	private static void checkList(List<Socket> sockets_list) {
		
		
		for(Socket x : sockets_list) {
			
			if(x.isClosed()) {
				
				sockets_list.remove(x);
			}
		}
	}

}
