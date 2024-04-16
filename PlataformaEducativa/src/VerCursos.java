/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author TUF
 */
import ConexionBD.ConexionBD;
import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class VerCursos extends JFrame {


    public VerCursos() {
        super("Cursos");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(800, 600);
        setLayout(new FlowLayout(FlowLayout.CENTER));

        // Conexión a la base de datos
        try (Connection conn = ConexionBD.getConnection()) {
            JPanel panelPrincipal = new JPanel();
            panelPrincipal.setLayout(new GridLayout(2,2,30,30));
            panelPrincipal.setPreferredSize(new Dimension(500,500));
            add(panelPrincipal,BorderLayout.CENTER);
            String sql = "Select * from obtenerMateriasEstudiante(2,'CURSANDO')";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet resultSet = pstmt.executeQuery()) {
                while (resultSet.next()) {
                JPanel panel = new JPanel();
                panel.setLayout(new BorderLayout());
                panel.setBorder(BorderFactory.createLineBorder(Color.BLACK));
                panel.setSize(100, 100);

                String nombreMateria = resultSet.getString("nombre_materia");
                String nivel = resultSet.getString("nivel");

                panel.add(new JLabel("Nombre: " + nombreMateria), BorderLayout.NORTH);
                panel.add(new JLabel("Nivel: " + nivel), BorderLayout.CENTER);
                JButton button =  new JButton("Ver detalles");
                button.setBackground(new Color(0x2277aa));
                button.setForeground(Color.WHITE);
                panel.add(button,BorderLayout.SOUTH);

                // Agregar ActionListener para manejar clics
                panel.addMouseListener(new MouseClickListener(nombreMateria));
                panelPrincipal.add(panel);
            }

            resultSet.close();
            pstmt.close();
            conn.close();
            }
            // Crear paneles según la cantidad de materias
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Configurar el diseño (GridLayout)
//        setLayout(new GridLayout(2, 3));
        setVisible(true);
    }

    // Clase interna para manejar clics en los paneles
    private class MouseClickListener extends MouseAdapter {
        private final String materia;

        public MouseClickListener(String materia) {
            this.materia = materia;
        }

        @Override
        public void mouseClicked(MouseEvent e) {
            // Aquí puedes abrir otro JFrame con más detalles de la materia
            // Implementa la lógica según tus necesidades.
        }
    }

}
