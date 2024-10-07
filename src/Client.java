import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JOptionPane;


public class Client {

    Socket s = null;
    //String name_client;
    BufferedReader in_stream = null;
    PrintWriter out_stream = null;
    Scanner sc = new Scanner(System.in);
    private boolean bool_listenSrv = true;
    private boolean bool_inptCapt = true;
    DefaultListModel<String> chat_clients;
    
    public Client() {

        String ip = "";
        int port = 0;

        try{

            System.out.print("IP: ");
            ip = sc.nextLine();
            

        } catch(Exception e){


        }


        boolean tmp = true;


        while(tmp){


            try{

                System.out.print("PORT: ");
                port = Integer.parseInt(sc.nextLine());
                tmp = false;
            
            } catch(NumberFormatException e){
    
                System.err.println("Si prega di inserire solo numeri");
                tmp = true;
            }

        }

        
        

        

        try {
            s = new Socket(ip, port);
            
            in_stream = new BufferedReader(new InputStreamReader(s.getInputStream()));
            out_stream = new PrintWriter(s.getOutputStream(), true);
            //this.name_client = name_client;

            // Creo thread che ascolta per messaggi del server
            new Thread(this::listenForServerMessages).start();

            // Creo thread che cattura sempre un input fino allas stringa 'exit'
            new Thread(this::captureInput).start();
            

            
            

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void listenForServerMessages() {
        while (bool_listenSrv) {
            try {
                String input = in_stream.readLine();

                if ("stop".equalsIgnoreCase(input)) {
                    System.out.print("\n - " + input);
                    closeConnection();
                    System.exit(0);
                    
                }
                
                else {
                    System.out.println("Risposta del server: " + input);

                }
                
            } catch (IOException e) {
                if (bool_listenSrv) {
                    e.printStackTrace();
                    System.err.println("Server terminato");
                    break;
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
                out_stream.println(input); // Invia il messaggio al server
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
            in_stream.close();
            out_stream.close();
            s.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    

}
