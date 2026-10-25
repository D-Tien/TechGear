package com.techgear.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Shared JDBC infrastructure; callers must close connections with try-with-resources. */
public final class DBConnection {
    private DBConnection() { }

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");
        if (url == null || url.isBlank() || user == null || user.isBlank()
                || password == null || password.isBlank()) {
            throw new SQLException("Configure DB_URL, DB_USER and DB_PASSWORD in the Tomcat environment.");
        }
        return DriverManager.getConnection(url, user, password);
    }
}
