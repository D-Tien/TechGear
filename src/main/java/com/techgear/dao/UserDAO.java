package com.techgear.dao;

import com.techgear.config.DBConnection;
import com.techgear.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/** JDBC only: each method closes its own connection, statement and result set. */
public class UserDAO {
    private static final String COLUMNS = "userId, roleId, username, fullName, email, passwordHash, phone, address, active, createdAt";

    private User readUser(ResultSet result) throws SQLException {
        return new User(result.getInt("userId"), result.getInt("roleId"), result.getString("username"),
                result.getString("fullName"), result.getString("email"), result.getString("passwordHash"),
                result.getString("phone"), result.getString("address"), result.getBoolean("active"),
                result.getTimestamp("createdAt").toLocalDateTime());
    }

    public User getUserById(int id) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT " + COLUMNS + " FROM dbo.Users WHERE userId = ?")) {
            statement.setInt(1, id);
            try (ResultSet result = statement.executeQuery()) { return result.next() ? readUser(result) : null; }
        }
    }

    public User getUserByUsername(String username) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT " + COLUMNS + " FROM dbo.Users WHERE username = ?")) {
            statement.setNString(1, username);
            try (ResultSet result = statement.executeQuery()) { return result.next() ? readUser(result) : null; }
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT " + COLUMNS + " FROM dbo.Users WHERE email = ?")) {
            statement.setNString(1, email);
            try (ResultSet result = statement.executeQuery()) { return result.next() ? readUser(result) : null; }
        }
    }

    public List<User> getAllUsers() throws SQLException { return searchUsers(""); }

    public List<User> searchUsers(String keyword) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT " + COLUMNS + " FROM dbo.Users WHERE ? = N'' OR CHARINDEX(?, username) > 0 OR CHARINDEX(?, fullName) > 0 OR CHARINDEX(?, email) > 0 ORDER BY userId DESC";
        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++) statement.setNString(i, keyword);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    User user = readUser(result);
                    user.setPasswordHash(null); // Never send password hashes to JSP.
                    users.add(user);
                }
            }
        }
        return users;
    }

    public boolean insertUser(User user) throws SQLException {
        String sql = "INSERT INTO dbo.Users(roleId, username, fullName, email, passwordHash, phone, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, user.getRoleId());
            statement.setNString(2, user.getUsername());
            statement.setNString(3, user.getFullName());
            statement.setNString(4, user.getEmail());
            statement.setNString(5, user.getPasswordHash());
            statement.setNString(6, user.getPhone());
            statement.setNString(7, user.getAddress());
            if (statement.executeUpdate() != 1) return false;
            try (ResultSet keys = statement.getGeneratedKeys()) { if (keys.next()) user.setUserId(keys.getInt(1)); }
            return true;
        }
    }

    // Profile updates only these fields: never roleId, active or username.
    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE dbo.Users SET fullName = ?, email = ?, phone = ?, address = ? WHERE userId = ? AND active = 1";
        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setNString(1, user.getFullName());
            statement.setNString(2, user.getEmail());
            statement.setNString(3, user.getPhone());
            statement.setNString(4, user.getAddress());
            statement.setInt(5, user.getUserId());
            return statement.executeUpdate() == 1;
        }
    }

    /** Admin update; lock active admins until commit to protect the last admin even with simultaneous requests. */
    public boolean updateUser(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                int activeAdmins = 0;
                boolean targetIsAdmin = false;
                String lockSql = "SELECT u.userId FROM dbo.Users u WITH (UPDLOCK, HOLDLOCK) JOIN dbo.Roles r ON u.roleId = r.roleId WHERE r.roleName = N'ADMIN' AND u.active = 1";
                try (PreparedStatement lock = connection.prepareStatement(lockSql); ResultSet result = lock.executeQuery()) {
                    while (result.next()) {
                        activeAdmins++;
                        if (result.getInt(1) == user.getUserId()) targetIsAdmin = true;
                    }
                }
                boolean newRoleIsAdmin;
                try (PreparedStatement role = connection.prepareStatement("SELECT roleName FROM dbo.Roles WHERE roleId = ?")) {
                    role.setInt(1, user.getRoleId());
                    try (ResultSet result = role.executeQuery()) {
                        if (!result.next()) throw new SQLException("Role does not exist.");
                        newRoleIsAdmin = "ADMIN".equals(result.getString(1));
                    }
                }
                if (targetIsAdmin && activeAdmins <= 1 && (!user.isActive() || !newRoleIsAdmin)) {
                    throw new IllegalArgumentException("Không thể khóa hoặc hạ quyền ADMIN cuối cùng.");
                }
                String sql = "UPDATE dbo.Users SET fullName = ?, email = ?, phone = ?, address = ?, roleId = ?, active = ? WHERE userId = ?";
                int updated;
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setNString(1, user.getFullName()); statement.setNString(2, user.getEmail());
                    statement.setNString(3, user.getPhone()); statement.setNString(4, user.getAddress());
                    statement.setInt(5, user.getRoleId()); statement.setBoolean(6, user.isActive()); statement.setInt(7, user.getUserId());
                    updated = statement.executeUpdate();
                }
                connection.commit();
                return updated == 1;
            } catch (SQLException | RuntimeException exception) {
                connection.rollback();
                throw exception;
            }
        }
    }

    public boolean updatePasswordHash(int userId, String passwordHash, String oldHash) throws SQLException {
        String sql = "UPDATE dbo.Users SET passwordHash = ? WHERE userId = ? AND passwordHash = ? AND active = 1";
        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setNString(1, passwordHash); statement.setInt(2, userId); statement.setNString(3, oldHash);
            return statement.executeUpdate() == 1;
        }
    }
}
