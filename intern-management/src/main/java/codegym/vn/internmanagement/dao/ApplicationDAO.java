package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.InternshipApplication;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public List<InternshipApplication> getAllApplications() {
        List<InternshipApplication> applications = new ArrayList<>();
        // Query joining with interns and users table to get names
        String sql = "SELECT a.*, u_intern.full_name as internName, u_reviewer.full_name as reviewerName " +
                "FROM internship_applications a " +
                "JOIN interns i ON a.intern_id = i.id " +
                "JOIN users u_intern ON i.user_id = u_intern.id " +
                "LEFT JOIN users u_reviewer ON a.reviewed_by = u_reviewer.id " +
                "ORDER BY a.application_date DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                applications.add(mapResultSetToApplication(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    public boolean updateApplicationStatus(Long id, String status, Long reviewerId, String reason) {
        String sql = "UPDATE internship_applications SET status = ?, reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP, rejection_reason = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setLong(2, reviewerId);
            statement.setString(3, reason);
            statement.setLong(4, id);

            // Also update the intern status based on application status
            if ("APPROVED".equals(status)) {
                String updateInternSql = "UPDATE interns SET status = 'APPROVED' WHERE id = (SELECT intern_id FROM internship_applications WHERE id = ?)";
                try (PreparedStatement updateInternStmt = connection.prepareStatement(updateInternSql)) {
                    updateInternStmt.setLong(1, id);
                    updateInternStmt.executeUpdate();
                }
            } else if ("REJECTED".equals(status)) {
                String updateInternSql = "UPDATE interns SET status = 'REJECTED' WHERE id = (SELECT intern_id FROM internship_applications WHERE id = ?)";
                try (PreparedStatement updateInternStmt = connection.prepareStatement(updateInternSql)) {
                    updateInternStmt.setLong(1, id);
                    updateInternStmt.executeUpdate();
                }
            }

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public InternshipApplication getApplicationById(Long id) {
        String sql = "SELECT a.*, u_intern.full_name as internName, u_reviewer.full_name as reviewerName " +
                "FROM internship_applications a " +
                "JOIN interns i ON a.intern_id = i.id " +
                "JOIN users u_intern ON i.user_id = u_intern.id " +
                "LEFT JOIN users u_reviewer ON a.reviewed_by = u_reviewer.id " +
                "WHERE a.id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToApplication(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private InternshipApplication mapResultSetToApplication(ResultSet rs) throws SQLException {
        InternshipApplication app = new InternshipApplication();
        app.setId(rs.getLong("id"));
        app.setInternId(rs.getLong("intern_id"));
        app.setApplicationDate(rs.getTimestamp("application_date"));
        app.setStatus(rs.getString("status"));
        long reviewedBy = rs.getLong("reviewed_by");
        if (!rs.wasNull()) {
            app.setReviewedBy(reviewedBy);
        }
        app.setReviewedAt(rs.getTimestamp("reviewed_at"));
        app.setRejectionReason(rs.getString("rejection_reason"));

        // Additional fields from JOIN
        app.setInternName(rs.getString("internName"));
        app.setReviewerName(rs.getString("reviewerName"));

        return app;
    }
}
