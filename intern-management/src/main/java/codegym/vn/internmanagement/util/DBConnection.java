package codegym.vn.internmanagement.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = System.getenv().getOrDefault(
            "DB_URL",
            "jdbc:mysql://localhost:3306/internship_management"
                    + "?useSSL=false"
                    + "&serverTimezone=UTC"
                    + "&allowPublicKeyRetrieval=true");

    private static final String USERNAME = System.getenv().getOrDefault("DB_USERNAME", "root");

    private static final String PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "12345");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}