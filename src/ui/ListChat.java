package ui;

import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import java.awt.event.*;

public class ListChat extends JPanel{
	
	private JList<String> chat_clients;
	
	public ListChat(DefaultListModel<String> tmp) {
		
		this.chat_clients = new JList<String>(tmp);
		this.add(chat_clients);
		this.chat_clients.setBounds(0, 0, 50, 50);

		this.chat_clients.addMouseListener(new MouseAdapter() {
         public void mouseClicked(MouseEvent me) {
            if (me.getClickCount() == 1) {
               JList target = (JList)me.getSource();
               int index = target.locationToIndex(me.getPoint());
               if (index >= 0) {
                  Object item = target.getModel().getElementAt(index);
                  JOptionPane.showMessageDialog(null, item.toString());
               }
            }
         }
      });


		try {


			System.out.println("Hai scelto: " + this.chat_clients.getSelectedValue().toString());
			
		} catch (Exception e) {

		}
		

		this.revalidate();
		this.repaint();

		//TODO mettere il metodo per un eventlistener a ogni socket nìin chat_clients
	}

}
