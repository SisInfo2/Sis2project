package metodos;

import ConexionBD.ConexionBD;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
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
   public static DefaultTableModel cargarDatos() {
        DefaultTableModel model = new DefaultTableModel();
        //devolver lista de materias que esta cursando
        // Establecer la conexión a la base de datos utilizando la clase ConexionBD
        try (Connection conn = ConexionBD.getConnection()) {
            // Llamar a la función de PostgreSQL
            String sql = "SELECT * FROM obtenerMateriasAbiertas(12)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                model.addColumn("id_grupo_materia"); 
                model.addColumn("Nombre Materia");
                model.addColumn("Nombre Docente");
                model.addColumn("Nivel");
                model.addColumn("Grupo");

                // Llenar el modelo con los datos de la consulta
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getString("id_grupo_materia"),
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
