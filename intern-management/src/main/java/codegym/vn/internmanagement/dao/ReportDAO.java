package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.WeeklyReport;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public boolean insertReport(WeeklyReport report) {
        String sql = "INSERT INTO weekly_reports (intern_id, mentor_id, week_number, title, content) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, report.getInternId());
            statement.setLong(2, report.getMentorId());
            statement.setInt(3, report.getWeekNumber());
            statement.setString(4, report.getTitle());
            statement.setString(5, report.getContent());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateReportFeedback(WeeklyReport report) {
        String sql = "UPDATE weekly_reports SET feedback = ?, status = 'REVIEWED', reviewed_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, report.getFeedback());
            statement.setLong(2, report.getId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<WeeklyReport> getReportsByInternId(Long internId) {
        List<WeeklyReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM weekly_reports WHERE intern_id = ? ORDER BY week_number DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, internId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    reports.add(mapResultSetToReport(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    public List<WeeklyReport> getReportsByMentorId(Long mentorId) {
        List<WeeklyReport> reports = new ArrayList<>();
        String sql = "SELECT wr.*, u.full_name as internName FROM weekly_reports wr JOIN interns i ON wr.intern_id = i.id JOIN users u ON i.user_id = u.id WHERE wr.mentor_id = ? ORDER BY wr.submitted_at DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, mentorId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    reports.add(mapResultSetToReport(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    public WeeklyReport getReportById(Long id) {
        String sql = "SELECT * FROM weekly_reports WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToReport(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private WeeklyReport mapResultSetToReport(ResultSet rs) throws SQLException {
        WeeklyReport report = new WeeklyReport();
        report.setId(rs.getLong("id"));
        report.setInternId(rs.getLong("intern_id"));
        report.setMentorId(rs.getLong("mentor_id"));
        report.setWeekNumber(rs.getInt("week_number"));
        report.setTitle(rs.getString("title"));
        report.setContent(rs.getString("content"));
        report.setSubmittedAt(rs.getTimestamp("submitted_at"));
        report.setFeedback(rs.getString("feedback"));
        report.setReviewedAt(rs.getTimestamp("reviewed_at"));
        report.setStatus(rs.getString("status"));
        try {
            report.setInternName(rs.getString("internName"));
        } catch (SQLException ignored) {
            // column might not exist in some queries
        }
        return report;
    }
}
