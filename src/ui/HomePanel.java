package ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;

import javax.swing.DefaultListModel;
import javax.swing.JPanel;

public class HomePanel extends JPanel{
	
	public HomePanel(DefaultListModel<String> tmp) {
		super();
		ListChat left_chat = new ListChat(tmp);
		ChosenChat right_chat = new ChosenChat();
		this.setLayout(new BorderLayout());
		left_chat.setBackground(Color.CYAN);
		left_chat.setPreferredSize(new Dimension(300, 600));
		right_chat.setPreferredSize(new Dimension(500, 600));
		this.add(left_chat, BorderLayout.WEST);
		this.add(right_chat, BorderLayout.CENTER);
	}

}
