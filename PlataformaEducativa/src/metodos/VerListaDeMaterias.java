/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package metodos;

/**
 *
 * @author kecha
 */  
import ConexionBD.ConexionBD;
import java.sql.*;
import javax.swing.table.DefaultTableModel;

public class VerListaDeMaterias {

    public static DefaultTableModel cargarDatos() {
        DefaultTableModel model = new DefaultTableModel();
        
        // Establecer la conexión a la base de datos utilizando la clase ConexionBD
        try (Connection conn = ConexionBD.getConnection()) {
            // Llamar a la función de PostgreSQL
            String sql = "SELECT * FROM obtenerMateriasAbiertas(5)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                
                model.addColumn("Nombre Materia");
                model.addColumn("Nombre Docente");
                model.addColumn("Nivel");
                model.addColumn("Grupo");

                // Llenar el modelo con los datos de la consulta
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getString("nombre_materia"),
                        rs.getString("nombre_docente"),
                        rs.getString("nivel"),
                        rs.getString("grupo")
                    });
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return model;
    }
}

    

