package codegym.vn.internmanagement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;
import codegym.vn.internmanagement.entity.MentorAssignment;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.DBConnection;

public class MentorDAO {

    private void ensureSchema() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement mentorsStmt = connection.prepareStatement(
                     "CREATE TABLE IF NOT EXISTS mentors (" +
                             "id BIGINT PRIMARY KEY AUTO_INCREMENT, " +
                             "user_id BIGINT NOT NULL UNIQUE, " +
                             "department VARCHAR(100) NOT NULL, " +
                             "position VARCHAR(100) NOT NULL, " +
                             "max_interns INT NOT NULL DEFAULT 5, " +
                             "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
                             "CONSTRAINT fk_mentor_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)" );
             PreparedStatement assignmentsStmt = connection.prepareStatement(
                     "CREATE TABLE IF NOT EXISTS mentor_assignments (" +
                             "id BIGINT PRIMARY KEY AUTO_INCREMENT, " +
                             "mentor_id BIGINT NOT NULL, " +
                             "intern_id BIGINT NOT NULL UNIQUE, " +
                             "assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
                             "CONSTRAINT fk_assignment_mentor FOREIGN KEY (mentor_id) REFERENCES mentors(id) ON DELETE CASCADE, " +
                             "CONSTRAINT fk_assignment_intern FOREIGN KEY (intern_id) REFERENCES interns(id) ON DELETE CASCADE)" )) {
            mentorsStmt.executeUpdate();
            assignmentsStmt.executeUpdate();
        }
    }

    public List<Mentor> findAll() {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT m.*, u.full_name, u.username, u.email FROM mentors m LEFT JOIN users u ON m.user_id = u.id ORDER BY m.id DESC";
        List<Mentor> mentors = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                mentors.add(mapMentor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mentors;
    }

    public List<User> findAvailableMentorUsers() {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT * FROM users WHERE role = 'MENTOR' AND id NOT IN (SELECT user_id FROM mentors) ORDER BY id DESC";
        List<User> users = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setFullName(rs.getString("full_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<Intern> findAvailableInterns() {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT i.*, u.full_name FROM interns i LEFT JOIN users u ON i.user_id = u.id WHERE i.id NOT IN (SELECT intern_id FROM mentor_assignments) ORDER BY i.id DESC";
        List<Intern> interns = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Intern intern = new Intern();
                intern.setId(rs.getLong("id"));
                intern.setStudentCode(rs.getString("student_code"));
                intern.setFullName(rs.getString("full_name"));
                interns.add(intern);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return interns;
    }

    public List<MentorAssignment> findAssignments() {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT ma.*, u.full_name AS mentor_name, i.student_code AS intern_code, intern_user.full_name AS intern_name " +
                "FROM mentor_assignments ma " +
                "LEFT JOIN mentors m ON ma.mentor_id = m.id " +
                "LEFT JOIN users u ON m.user_id = u.id " +
                "LEFT JOIN interns i ON ma.intern_id = i.id " +
                "LEFT JOIN users intern_user ON i.user_id = intern_user.id " +
                "ORDER BY ma.id DESC";
        List<MentorAssignment> assignments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                MentorAssignment assignment = new MentorAssignment();
                assignment.setId(rs.getLong("id"));
                assignment.setMentorId(rs.getLong("mentor_id"));
                assignment.setInternId(rs.getLong("intern_id"));
                assignment.setAssignedAt(rs.getString("assigned_at"));
                assignment.setMentorName(rs.getString("mentor_name"));
                assignment.setInternName(rs.getString("intern_name"));
                assignment.setInternCode(rs.getString("intern_code"));
                assignments.add(assignment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    public List<MentorAssignment> findMentorWorkloadStats() {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT m.id, m.user_id, m.department, m.position, m.max_interns, u.full_name, COUNT(ma.id) AS assigned_count " +
                "FROM mentors m " +
                "LEFT JOIN users u ON m.user_id = u.id " +
                "LEFT JOIN mentor_assignments ma ON ma.mentor_id = m.id " +
                "GROUP BY m.id, m.user_id, m.department, m.position, m.max_interns, u.full_name " +
                "ORDER BY assigned_count DESC, u.full_name ASC";
        List<MentorAssignment> stats = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                MentorAssignment assignment = new MentorAssignment();
                assignment.setMentorId(rs.getLong("id"));
                assignment.setMentorName(rs.getString("full_name"));
                assignment.setInternCode(rs.getString("assigned_count"));
                assignment.setMaxInterns(rs.getInt("max_interns"));
                assignment.setAssignedAt(rs.getString("department") + " / " + rs.getString("position"));
                stats.add(assignment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public boolean insert(Mentor mentor) {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "INSERT INTO mentors (user_id, department, position, max_interns) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, mentor.getUserId());
            statement.setString(2, mentor.getDepartment());
            statement.setString(3, mentor.getPosition());
            statement.setInt(4, mentor.getMaxInterns());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignMentor(Long mentorId, Long internId) {
        try {
            ensureSchema();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String checkSql = "SELECT COUNT(*) FROM mentor_assignments WHERE intern_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement checkStatement = connection.prepareStatement(checkSql)) {
            checkStatement.setLong(1, internId);
            try (ResultSet rs = checkStatement.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "INSERT INTO mentor_assignments (mentor_id, intern_id) VALUES (?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, mentorId);
            statement.setLong(2, internId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Mentor mapMentor(ResultSet rs) throws SQLException {
        Mentor mentor = new Mentor();
        mentor.setId(rs.getLong("id"));
        mentor.setUserId(rs.getLong("user_id"));
        mentor.setDepartment(rs.getString("department"));
        mentor.setPosition(rs.getString("position"));
        mentor.setMaxInterns(rs.getInt("max_interns"));
        mentor.setFullName(rs.getString("full_name"));
        mentor.setUsername(rs.getString("username"));
        mentor.setEmail(rs.getString("email"));
        return mentor;
    }
}
