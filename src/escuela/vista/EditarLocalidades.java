package escuela.vista;
/* COMMENTARIO */
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.LinkedList;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.ListModel;
import javax.swing.event.ListDataListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableColumnModel;
import javax.swing.table.TableModel;

import org.apache.log4j.Logger;

import escuela.EscuelaException;
import escuela.dao.AccesoADatosException;
import escuela.dao.EscuelaDAO;
import escuela.modelo.Localidad;

public class EditarLocalidades extends JFrame implements ActionListener {

	private static final Logger LOGGER = Logger.getLogger(EditarLocalidades.class);
	
	
	public EditarLocalidades() {
		// TODO Auto-generated constructor stub
		
		
		JTable table = new JTable (new LocalidadesTableModel());
		this.getContentPane().add(table);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.pack();
		this.setVisible(true);
		
	}
	
	public static void main(String[] args) {
		new EditarLocalidades();
	}
	
	
	@Override
	public void actionPerformed(ActionEvent e) {
				
	}

	
	
	
	private class LocalidadesTableModel extends AbstractTableModel
	{

		List<Localidad> localidades = new LinkedList<Localidad>();
				
		public LocalidadesTableModel() {
			
			try {
				this.localidades = Localidad.getLocalidades();
			} catch (EscuelaException e) {
				LOGGER.error (e, e);
			}
		}

		@Override
		public int getRowCount() {
			// TODO Auto-generated method stub
			return this.localidades.size();
		}

		@Override
		public int getColumnCount() {
			// TODO Auto-generated method stub
			return 4;
		}

		@Override
		public Object getValueAt(int rowIndex, int columnIndex) {
			Localidad localidad = this.localidades.get(rowIndex);
			switch (columnIndex) {
			case 0: return localidad.getCodigo();
			case 1:	return localidad.getNombre();
			case 2: return localidad.getProvincia();
			case 3:	return localidad.getCodigoPostal();
			default:
				return null;
			}
		}
		
		
		
		
		
	
		
		@Override
		public boolean isCellEditable(int rowIndex, int columnIndex) {
			return columnIndex == 1;
		}
		
		
		@Override
		public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
			Localidad l = this.localidades.get(rowIndex);
			if (columnIndex == 1) {
				l.setNombre((String)aValue);
				try {
					new EscuelaDAO().guardar(l);
				} catch (AccesoADatosException e) {
					LOGGER.error(e, e);
				}
				
			}
		}
		
		@Override
		public String getColumnName(int column) {
			
			return "Columna " + column;
		}
				
	}
	
}
