package ui;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;

public class Frame extends JFrame{
	
	HomePanel hp;
	
	public Frame(DefaultListModel<String> tmp) {
		
		
		super("Chat");
		
		hp = new HomePanel(tmp);
				 
				 
		this.setSize(800, 600);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setResizable(false);
		this.setLocationRelativeTo(null);
		this.getContentPane().add(hp);
		this.setVisible(true);
		
	}
	
	public void updateList(DefaultListModel<String> tmp) {
		this.getContentPane().remove(hp);
		hp = new HomePanel(tmp);
		this.getContentPane().add(hp);
		this.repaint();
		this.revalidate();
	}

}
