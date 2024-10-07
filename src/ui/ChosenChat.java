package ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.net.Socket;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTextArea;

public class ChosenChat extends JPanel{
	
	public ChosenChat(/* Socket client */) {

		//avvia i vari thread per lettura e scrittura

		this.setLayout(new BorderLayout());

		JPanel bottom_panel = new JPanel();

		JTextArea spazio_msg = new JTextArea("Inizia a scrivere");

		bottom_panel.add(spazio_msg);

		bottom_panel.setBackground(Color.GREEN);

		JButton send_msg = new JButton();

		bottom_panel.add(send_msg, BorderLayout.EAST);

		this.add(bottom_panel, BorderLayout.SOUTH);

	}

}
