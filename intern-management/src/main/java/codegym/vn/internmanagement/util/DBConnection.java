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
    private static final String USERNAME = requiredEnvironment("DB_USERNAME");
    private static final String PASSWORD = requiredEnvironment("DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection()
            throws SQLException {
        return DriverManager.getConnection(
                URL,
                USERNAME,
                PASSWORD
        );
    }

    private static String requiredEnvironment(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException(name + " environment variable is required.");
        }
        return value;
    }
}
