package ui;

import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.JPanel;

public class ListChat extends JPanel{
	
	private JList<String> chat_clients;
	
	public ListChat(DefaultListModel<String> tmp) {
		
		this.chat_clients = new JList<String>(tmp);
		this.add(chat_clients);
		this.chat_clients.setBounds(0, 0, 50, 50);
		this.revalidate();
		this.repaint();
	}

}
