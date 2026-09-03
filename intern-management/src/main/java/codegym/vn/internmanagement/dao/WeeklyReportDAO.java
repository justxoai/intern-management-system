package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.WeeklyReport;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WeeklyReportDAO {

    public List<WeeklyReport> findByInternId(Long internId) {
        List<WeeklyReport> list = new ArrayList<>();
        String sql = "SELECT wr.*, mu.full_name AS mentor_name, mu.email AS mentor_email " +
                     "FROM weekly_reports wr " +
                     "LEFT JOIN mentors m ON wr.mentor_id = m.id " +
                     "LEFT JOIN users mu ON m.user_id = mu.id " +
                     "WHERE wr.intern_id = ? " +
                     "ORDER BY wr.week_number DESC, wr.submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, internId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WeeklyReport wr = mapResultSet(rs);
                    wr.setMentorName(rs.getString("mentor_name"));
                    wr.setMentorEmail(rs.getString("mentor_email"));
                    list.add(wr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<WeeklyReport> findByMentorUserId(Long mentorUserId) {
        List<WeeklyReport> list = new ArrayList<>();
        String sql = "SELECT wr.*, iu.full_name AS intern_name, i.student_code, iu.email AS intern_email " +
                     "FROM weekly_reports wr " +
                     "JOIN mentors m ON wr.mentor_id = m.id " +
                     "JOIN interns i ON wr.intern_id = i.id " +
                     "JOIN users iu ON i.user_id = iu.id " +
                     "WHERE m.user_id = ? " +
                     "ORDER BY wr.submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, mentorUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WeeklyReport wr = mapResultSet(rs);
                    wr.setInternName(rs.getString("intern_name"));
                    wr.setStudentCode(rs.getString("student_code"));
                    wr.setInternEmail(rs.getString("intern_email"));
                    list.add(wr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public WeeklyReport findById(Long id) {
        String sql = "SELECT wr.*, iu.full_name AS intern_name, i.student_code, iu.email AS intern_email, " +
                     "mu.full_name AS mentor_name, mu.email AS mentor_email " +
                     "FROM weekly_reports wr " +
                     "LEFT JOIN interns i ON wr.intern_id = i.id " +
                     "LEFT JOIN users iu ON i.user_id = iu.id " +
                     "LEFT JOIN mentors m ON wr.mentor_id = m.id " +
                     "LEFT JOIN users mu ON m.user_id = mu.id " +
                     "WHERE wr.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WeeklyReport wr = mapResultSet(rs);
                    wr.setInternName(rs.getString("intern_name"));
                    wr.setStudentCode(rs.getString("student_code"));
                    wr.setInternEmail(rs.getString("intern_email"));
                    wr.setMentorName(rs.getString("mentor_name"));
                    wr.setMentorEmail(rs.getString("mentor_email"));
                    return wr;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Long findAssignedMentorIdByInternId(Long internId) {
        String sql = "SELECT mentor_id FROM mentor_assignments WHERE intern_id = ? AND status = 'ACTIVE' LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, internId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("mentor_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback: check tasks
        String fallbackSql = "SELECT mentor_id FROM tasks WHERE intern_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
            ps.setLong(1, internId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("mentor_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback: first mentor
        String firstMentorSql = "SELECT id FROM mentors ORDER BY id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(firstMentorSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(WeeklyReport report) {
        String sql = "INSERT INTO weekly_reports (intern_id, mentor_id, week_number, title, content, status) " +
                     "VALUES (?, ?, ?, ?, ?, 'SUBMITTED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, report.getInternId());
            ps.setLong(2, report.getMentorId());
            ps.setInt(3, report.getWeekNumber());
            ps.setString(4, report.getTitle());
            ps.setString(5, report.getContent());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) report.setId(rs.getLong(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateContent(Long id, String title, String content) {
        String sql = "UPDATE weekly_reports SET title = ?, content = ? WHERE id = ? AND status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setLong(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean saveFeedback(Long id, String feedback) {
        String sql = "UPDATE weekly_reports SET feedback = ?, reviewed_at = CURRENT_TIMESTAMP, status = 'REVIEWED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, feedback);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private WeeklyReport mapResultSet(ResultSet rs) throws SQLException {
        WeeklyReport wr = new WeeklyReport();
        wr.setId(rs.getLong("id"));
        wr.setInternId(rs.getLong("intern_id"));
        wr.setMentorId(rs.getLong("mentor_id"));
        wr.setWeekNumber(rs.getInt("week_number"));
        wr.setTitle(rs.getString("title"));
        wr.setContent(rs.getString("content"));
        wr.setSubmittedAt(rs.getTimestamp("submitted_at"));
        wr.setFeedback(rs.getString("feedback"));
        wr.setReviewedAt(rs.getTimestamp("reviewed_at"));
        wr.setStatus(rs.getString("status"));
        return wr;
    }
}
