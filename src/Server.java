import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

    public static void main(String[] args) throws Exception {
        ServerSocket ss = new ServerSocket(3333);
        System.out.println("Server avviato");
        Socket s = ss.accept();
        DataInputStream din = new DataInputStream(s.getInputStream());
        DataOutputStream dout = new DataOutputStream(s.getOutputStream());

        String str = "";
        while (!str.equals("stop")) {
            str = din.readUTF();
            System.out.println("Dal client: " + str);
        }

        din.close();
        dout.close();
        s.close();
        ss.close();
        System.out.println("Connessione chiusa.");
    }
}
