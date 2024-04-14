package metodos;

import ConexionBD.ConexionBD;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;
import javax.swing.JTable;


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author kecha
 */
public class InscribirseMateria {
   public static void cargarMateriasEstudiante(DefaultTableModel materiasTableModel) {
        try {
            Connection con = ConexionBD.getConnection();
            CallableStatement stmt = con.prepareCall("{Select * from obtenerMateriasEstudiante(?, ?) }");
            stmt.setInt(1, 123); // Reemplazar 123 por el ID del estudiante
            stmt.setString(2, "APROBADO"); // Reemplazar "APROBADO" por el tipo de materias a obtener
            ResultSet rs = stmt.executeQuery();

            // Limpiar tabla
            materiasTableModel.setRowCount(0);

            // Llenar la tabla con los resultados de la consulta
            while (rs.next()) {
                Object[] row = {
                        rs.getInt("id_materia"),
                        rs.getString("nombre_materia"),
                        rs.getString("nivel"),
                        rs.getInt("promedio")
                };
                materiasTableModel.addRow(row);
            }

            // Cerrar conexión
            ConexionBD.close(con, stmt, rs);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
   
   
    public static void inscribirse(JTable jTable2, DefaultTableModel materiasTableModel) {
        int selectedRow = jTable2.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(null, "Por favor, seleccione una materia para inscribirse.", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        int idMateria = (int) materiasTableModel.getValueAt(selectedRow, 0);

        try {
            Connection con = ConexionBD.getConnection();
            CallableStatement stmt = con.prepareCall("{ call inscribirse(?, ?) }");
            stmt.setInt(1, 123); // Reemplazar 123 por el ID del estudiante
            stmt.setInt(2, idMateria);
            stmt.executeUpdate();

            // Cerrar conexión
            ConexionBD.closeConnection(con);

            // Actualizar la tabla después de inscribirse
            cargarMateriasEstudiante(materiasTableModel);

            JOptionPane.showMessageDialog(null, "Te has inscrito correctamente en la materia.", "Éxito", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(null, "Ha ocurrido un error al inscribirse en la materia.", "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
}
