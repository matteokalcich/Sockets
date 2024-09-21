import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class Client {

    Socket s = null;
    BufferedReader din = null;
    PrintWriter dout = null;
    Scanner sc = new Scanner(System.in);
    private boolean bool_listenSrv = true;
    private boolean bool_inptCapt = true;

    public Client() {
        try {
            s = new Socket("192.168.1.2", 3333);

            din = new BufferedReader(new InputStreamReader(s.getInputStream()));
            dout = new PrintWriter(new OutputStreamWriter(s.getOutputStream()), true);

            // Start a separate thread to listen for server messages
            new Thread(this::listenForServerMessages).start();

            // Start a thread to capture the input until the user writes "stop"
            new Thread(this::captureInput).start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void listenForServerMessages() {
        while (bool_listenSrv) {
            try {
                String input = din.readLine();

                if ("stop".equalsIgnoreCase(input)) {
                    System.out.println(input);
                    closeConnection();
                    System.exit(0);
                } else {
                    System.out.println("Risposta del server: " + input);
                }
            } catch (IOException e) {
                if (bool_listenSrv) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void captureInput() {
        System.out.println("Inizia a scrivere");
        while (bool_inptCapt) {
            try {
                System.out.print("\n - ");
                String input = sc.nextLine();
                dout.println(input); // Invia il messaggio al server
                if ("chiuso".equalsIgnoreCase(input)) {
                    bool_listenSrv = false;
                }
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
