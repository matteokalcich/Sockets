import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;

public class Client {

    Socket s = null;
    DataInputStream din = null;
    DataOutputStream dout = null;
    Scanner sc = new Scanner(System.in);
    private boolean bool_listenSrv = true;

    private boolean bool_inptCapt = true;

    public Client() {
        try {
            s = new Socket("192.168.1.4", 3333);

            din = new DataInputStream(s.getInputStream());
            dout = new DataOutputStream(s.getOutputStream());

            // Start a separate thread to listen for server messages
            new Thread(this::listenForServerMessages).start();

            // Start a thread to capture the input until the user writes "stop"
            new Thread(this::captureInput).start();

            // System.out.println("Quante volte vuoi scrivere?");
            // System.out.print("> ");
            // int volte = Integer.parseInt(sc.nextLine());

            // for (int i = 0; i < volte; i++) {
            // richiesta();
            // }

        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void listenForServerMessages() {
        while (bool_listenSrv) {
            try {
                String input = din.readUTF();

                // System.out.println(input);
                if (input.equals("stop")) {

                    System.out.println(input);

                    closeConnection();

                    System.exit(0);

                }
            } catch (IOException e) {
                if (bool_listenSrv) {
                    e.printStackTrace();
                }
                // If not running, the socket has been closed intentionally
            }
        }
    }

    private void captureInput() {

        System.out.println("Inizia a scrivere");

        while (bool_inptCapt) {

            try {

                System.out.print("\n - ");

                String input = sc.nextLine();

                dout.writeUTF(input);

            } catch (Exception e) {

                e.printStackTrace();

            }
        }

    }

    private void closeConnection() {
        try {
            bool_listenSrv = false;

            din.close();

            dout.close();

            s.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
