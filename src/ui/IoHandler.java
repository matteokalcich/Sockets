package ui;

import java.util.stream.Stream;

public class IoHandler {


    public static synchronized void Print(String out) {
        System.out.print(out);

    }

    public static synchronized void PrintMessage(String out) {
        System.out.println(out);

    }

    public static synchronized String ReadMessage(Stream in_stream) {

        return "";
    }



}
