package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Intern entity.
 * Supports CRUD, profile management, and dynamic searching/filtering.
 */
public class InternDAO {

    /**
     * Insert a new intern profile.
     *
     * @param intern Intern entity
     * @return true if successful, false otherwise
     */
    public boolean insert(Intern intern) {
        String sql = "INSERT INTO interns (user_id, student_code, university, major, date_of_birth, gender, address, phone, email, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, intern.getUserId());
            statement.setString(2, intern.getStudentCode());
            statement.setString(3, intern.getUniversity());
            statement.setString(4, intern.getMajor());
            statement.setDate(5, intern.getDateOfBirth() != null ? Date.valueOf(intern.getDateOfBirth()) : null);
            statement.setString(6, intern.getGender());
            statement.setString(7, intern.getAddress());
            statement.setString(8, intern.getPhone());
            statement.setString(9, intern.getEmail());
            statement.setString(10, intern.getStatus() != null ? intern.getStatus() : "PENDING");

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find intern profile by ID.
     *
     * @param id Intern ID
     * @return Intern object or null
     */
    public Intern findById(Long id) {
        String sql = "SELECT i.*, u.full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE i.id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIntern(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update existing intern profile.
     *
     * @param intern Intern entity with updated fields
     * @return true if successful, false otherwise
     */
    public boolean update(Intern intern) {
        String sql = "UPDATE interns SET student_code = ?, university = ?, major = ?, date_of_birth = ?, gender = ?, address = ?, phone = ?, email = ?, status = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, intern.getStudentCode());
            statement.setString(2, intern.getUniversity());
            statement.setString(3, intern.getMajor());
            statement.setDate(4, intern.getDateOfBirth() != null ? Date.valueOf(intern.getDateOfBirth()) : null);
            statement.setString(5, intern.getGender());
            statement.setString(6, intern.getAddress());
            statement.setString(7, intern.getPhone());
            statement.setString(8, intern.getEmail());
            statement.setString(9, intern.getStatus());
            statement.setLong(10, intern.getId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Search and filter interns dynamically.
     *
     * @param keyword    Keyword to match student_code, full_name, or email
     * @param university University filter
     * @param major      Major filter
     * @param status     Status filter
     * @return List of matching Intern objects
     */
    public List<Intern> search(String keyword, String university, String major, String status) {
        List<Intern> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.*, u.full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.student_code LIKE ? OR u.full_name LIKE ? OR i.email LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (university != null && !university.trim().isEmpty()) {
            sql.append("AND i.university LIKE ? ");
            params.add("%" + university.trim() + "%");
        }

        if (major != null && !major.trim().isEmpty()) {
            sql.append("AND i.major LIKE ? ");
            params.add("%" + major.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(status.trim());
        }

        sql.append("ORDER BY i.id DESC");

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    list.add(mapResultSetToIntern(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Intern mapResultSetToIntern(ResultSet rs) throws SQLException {
        Intern intern = new Intern();
        intern.setId(rs.getLong("id"));
        intern.setUserId(rs.getLong("user_id"));
        intern.setStudentCode(rs.getString("student_code"));
        intern.setUniversity(rs.getString("university"));
        intern.setMajor(rs.getString("major"));
        
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            intern.setDateOfBirth(dob.toLocalDate());
        }
        
        intern.setGender(rs.getString("gender"));
        intern.setAddress(rs.getString("address"));
        intern.setPhone(rs.getString("phone"));
        intern.setEmail(rs.getString("email"));
        intern.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            intern.setCreatedAt(createdAt.toLocalDateTime());
        }

        try {
            intern.setFullName(rs.getString("full_name"));
        } catch (SQLException ignored) {
            // Column may not be in ResultSet if join wasn't performed
        }

        return intern;
    }
}
