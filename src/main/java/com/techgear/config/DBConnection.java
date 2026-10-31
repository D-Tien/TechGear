package com.techgear.config;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Shared JDBC infrastructure; callers must close connections with try-with-resources. */
public final class DBConnection {
    private static final Map<String, String> DOT_ENV = loadDotEnv();

    private DBConnection() { }

    private static Map<String, String> loadDotEnv() {
        Map<String, String> map = new HashMap<>();
        List<Path> candidatePaths = new ArrayList<>();
        candidatePaths.add(Paths.get(".env"));
        candidatePaths.add(Paths.get("..", ".env"));

        try {
            URL resource = DBConnection.class.getResource("/");
            if (resource != null) {
                File dir = new File(resource.toURI());
                while (dir != null) {
                    File envCandidate = new File(dir, ".env");
                    if (envCandidate.exists()) {
                        candidatePaths.add(envCandidate.toPath());
                        break;
                    }
                    dir = dir.getParentFile();
                }
            }
        } catch (Exception ignored) { }

        for (Path path : candidatePaths) {
            if (Files.exists(path)) {
                try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        int eq = line.indexOf('=');
                        if (eq > 0) {
                            String k = line.substring(0, eq).trim();
                            String v = line.substring(eq + 1).trim();
                            if ((v.startsWith("\"") && v.endsWith("\"")) || (v.startsWith("'") && v.endsWith("'"))) {
                                if (v.length() >= 2) {
                                    v = v.substring(1, v.length() - 1);
                                }
                            }
                            map.putIfAbsent(k, v);
                        }
                    }
                } catch (IOException ignored) { }
                break;
            }
        }
        return map;
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.isBlank()) {
            return value;
        }
        String envValue = DOT_ENV.get(key);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }
        return defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        String url = getEnv("DB_URL", "jdbc:sqlserver://localhost:1433;databaseName=TechGearDB_Local;encrypt=true;trustServerCertificate=true");
        String user = getEnv("DB_USER", "sa");
        String password = getEnv("DB_PASSWORD", "123456");

        if (url == null || url.isBlank() || user == null || user.isBlank()
                || password == null || password.isBlank()) {
            throw new SQLException("Configure DB_URL, DB_USER and DB_PASSWORD in the Tomcat environment or .env file.");
        }
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException error) {
            throw new SQLException("SQL Server JDBC driver is missing.", error);
        }
        return DriverManager.getConnection(url, user, password);
    }
}
