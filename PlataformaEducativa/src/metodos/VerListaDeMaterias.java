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
        //devolver lista de materias que esta cursando
        // Establecer la conexión a la base de datos utilizando la clase ConexionBD
     // Establecer la conexión a la base de datos utilizando la clase ConexionBD
    try (Connection conn = ConexionBD.getConnection()) {
        // Llamar a la función de PostgreSQL
        String sql = "SELECT * FROM obtenerMateriasEstudiante(?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int id_est=2;
            pstmt.setInt(1, id_est); // Establecer el primer parámetro de la función (id_est)
            String tipo="APROBADO";
            pstmt.setString(2, tipo); // Establecer el segundo parámetro de la función (tipo)
            
            try (ResultSet rs = pstmt.executeQuery()) {
                model.addColumn("Nombre Materia");
                model.addColumn("Nivel");
                model.addColumn("Promedio");

                // Llenar el modelo con los datos de la consulta
                while (rs.next()) {
                    model.addRow(new Object[]{
                       
                        rs.getString("nombre_materia"),
                        rs.getString("nivel"),
                        rs.getInt("promedio")
                    });
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return model;   
    }
    
    
}

    

