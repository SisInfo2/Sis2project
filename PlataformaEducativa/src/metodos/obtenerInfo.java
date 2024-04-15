/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package metodos;

import ConexionBD.ConexionBD;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import javax.swing.JTable;

/**
 *
 * @author kecha
 */
public class obtenerInfo {
     public static DefaultTableModel cargarDatos() {
        DefaultTableModel model = new DefaultTableModel();
        //devolver lista de materias que esta cursando
        // Establecer la conexión a la base de datos utilizando la clase ConexionBD
        try (Connection conn = ConexionBD.getConnection()) {
            // Llamar a la función de PostgreSQL
            int valor = 1;
            String sql = "SELECT * FROM obtenerMateriasAbiertas(17)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
               
                model.addColumn("titulo");
                model.addColumn("descripcion");
                // Llenar el modelo con los datos de la consulta
                while (rs.next()) {
                  model.addRow(new Object[]{
                     rs.getString("titulo"),
                     rs.getString("descripcion"),
                       
                      
                    });
                }
            }
        } catch (SQLException e ) {
            e.printStackTrace();
        }
        
        return model;
    }
}
