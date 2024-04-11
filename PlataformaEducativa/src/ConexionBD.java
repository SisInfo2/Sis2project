/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author kecha
 */
import java.sql.*;

public class ConexionBD {
    private static final String URL = "jdbc:postgresql://oregon-postgres.render.com:5432/sisinfo2db";
    private static final String USER = "kevin_123";
    private static final String PASSWORD = "8baO6G0RmY0HjY2PqSrScxaR3p4aI3We";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void close(Connection con, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public static void closeConnection(Connection con) {
        try {
            if (con != null) con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
