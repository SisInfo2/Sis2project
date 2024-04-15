/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package metodos;

import ConexionBD.ConexionBD;
import java.sql.PreparedStatement;
import javax.swing.JOptionPane;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author kecha
 */
public class Inscribir {

    
 public void inscribirEstudiante(int idGrupo) {
        try {
            // Obtener conexión utilizando el método getConnection() de tu clase ConexionBD
            Connection conn = ConexionBD.getConnection();
            
            // Aquí se crea el PreparedStatement para la inserción en la tabla "clase"
            PreparedStatement pstmt = conn.prepareStatement("call inscribirse(12, ?)");
    
            pstmt.setInt(1, idGrupo);
            
            // Se ejecuta la inserción en la tabla "clase"
            pstmt.executeUpdate();
            
            // Se cierra el PreparedStatement
            pstmt.close();
            
            // Cerrar la conexión
            ConexionBD.closeConnection(conn);
            
            JOptionPane.showMessageDialog(null, "Estudiante inscrito correctamente.");
        } catch (SQLException ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error-El Estudiante no puede cursar esta materia");
        }
    }
}
