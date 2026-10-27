package com.techgear.dao;

import com.techgear.config.DBConnection;
import com.techgear.model.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    public List<Role> getAllRoles() throws SQLException {
        List<Role> roles = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT roleId, roleName FROM dbo.Roles ORDER BY roleId");
             ResultSet result = statement.executeQuery()) {
            while (result.next()) roles.add(new Role(result.getInt("roleId"), result.getString("roleName")));
        }
        return roles;
    }

    public Role getRoleById(int id) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT roleId, roleName FROM dbo.Roles WHERE roleId = ?")) {
            statement.setInt(1, id);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? new Role(result.getInt("roleId"), result.getString("roleName")) : null;
            }
        }
    }

    public Role getRoleByName(String name) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT roleId, roleName FROM dbo.Roles WHERE roleName = ?")) {
            statement.setNString(1, name);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? new Role(result.getInt("roleId"), result.getString("roleName")) : null;
            }
        }
    }
}
