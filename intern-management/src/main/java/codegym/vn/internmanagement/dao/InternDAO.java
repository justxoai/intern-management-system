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

public class InternDAO {

    public boolean insert(Intern intern) {
        String sql = "INSERT INTO interns (user_id, student_code, university, major, date_of_birth, gender, address, phone, email, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            if (intern.getUserId() != null && intern.getUserId() > 0) {
                statement.setLong(1, intern.getUserId());
            } else {
                statement.setNull(1, java.sql.Types.BIGINT);
            }
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

    public Intern findById(Long id) {
        String sql = "SELECT i.*, COALESCE(u.full_name, i.email) AS full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE i.id = ?";

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

    public boolean update(Intern intern) {
        String sql = "UPDATE interns SET user_id = ?, student_code = ?, university = ?, major = ?, date_of_birth = ?, gender = ?, address = ?, phone = ?, email = ?, status = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            if (intern.getUserId() != null && intern.getUserId() > 0) {
                statement.setLong(1, intern.getUserId());
            } else {
                statement.setNull(1, java.sql.Types.BIGINT);
            }
            statement.setString(2, intern.getStudentCode());
            statement.setString(3, intern.getUniversity());
            statement.setString(4, intern.getMajor());
            statement.setDate(5, intern.getDateOfBirth() != null ? Date.valueOf(intern.getDateOfBirth()) : null);
            statement.setString(6, intern.getGender());
            statement.setString(7, intern.getAddress());
            statement.setString(8, intern.getPhone());
            statement.setString(9, intern.getEmail());
            statement.setString(10, intern.getStatus());
            statement.setLong(11, intern.getId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Intern> search(String keyword, String university, String major, String status) {
        List<Intern> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.*, COALESCE(u.full_name, i.email) AS full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE 1=1 ");
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
        try {
            long uid = rs.getLong("user_id");
            if (!rs.wasNull()) intern.setUserId(uid);
        } catch (Exception ignored) {}
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
            String fn = rs.getString("full_name");
            intern.setFullName(fn != null && !fn.isBlank() ? fn : intern.getEmail());
        } catch (SQLException ignored) {
            if (intern.getFullName() == null) intern.setFullName(intern.getEmail());
        }

        return intern;
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM interns WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find all interns assigned to a specific mentor.
     * Matches either mentors.user_id or mentors.id.
     */
    public List<Intern> findByMentorId(Long mentorUserIdOrMentorId) {
        List<Intern> list = new ArrayList<>();
        String sql = "SELECT i.*, COALESCE(u.full_name, i.email) AS full_name " +
                     "FROM interns i " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "JOIN mentor_assignments ma ON i.id = ma.intern_id " +
                     "JOIN mentors m ON ma.mentor_id = m.id " +
                     "WHERE (m.user_id = ? OR m.id = ?) AND ma.status = 'ACTIVE' " +
                     "ORDER BY i.id DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, mentorUserIdOrMentorId);
            statement.setLong(2, mentorUserIdOrMentorId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToIntern(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Find all interns assigned to a specific mentor record ID (mentors.id).
     */
    public List<Intern> findByMentorRecordId(Long mentorRecordId) {
        List<Intern> list = new ArrayList<>();
        String sql = "SELECT i.*, COALESCE(u.full_name, i.email) AS full_name " +
                     "FROM interns i " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "JOIN mentor_assignments ma ON i.id = ma.intern_id " +
                     "WHERE ma.mentor_id = ? AND ma.status = 'ACTIVE' " +
                     "ORDER BY i.id DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, mentorRecordId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToIntern(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Find intern profile by their users.id (used after login to get intern's record).
     */
    public Intern findByUserId(Long userId) {
        String sql = "SELECT i.*, COALESCE(u.full_name, i.email) AS full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE i.user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) return mapResultSetToIntern(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
