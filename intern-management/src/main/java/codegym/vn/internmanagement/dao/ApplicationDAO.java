package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Application;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the 'internship_applications' table.
 */
public class ApplicationDAO {

    public List<Application> findAll(String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, i.student_code, i.university, i.major, " +
            "       COALESCE(u.full_name, i.email) AS intern_name, COALESCE(u.email, i.email) AS intern_email, " +
            "       ru.full_name AS reviewer_name " +
            "FROM internship_applications a " +
            "JOIN interns i ON a.intern_id = i.id " +
            "LEFT JOIN users u   ON i.user_id   = u.id " +
            "LEFT JOIN users ru ON a.reviewed_by = ru.id " +
            "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isBlank()) {
            sql.append("AND a.status = ? ");
            params.add(statusFilter);
        }
        sql.append("ORDER BY a.id DESC");
        return query(sql.toString(), params.toArray());
    }

    public long countPending() {
        String sql = "SELECT COUNT(*) FROM internship_applications WHERE status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Approve an application:
     * - Updates internship_applications.status → APPROVED
     * - Updates interns.status → APPROVED
     * - Updates documents (INTERNSHIP_APPLICATION) → APPROVED
     */
    public boolean approve(Long appId, Long reviewerId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. update application
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE internship_applications SET status='APPROVED', reviewed_by=?, reviewed_at=NOW() WHERE id=?")) {
                    ps.setLong(1, reviewerId); ps.setLong(2, appId);
                    ps.executeUpdate();
                }
                // 2. update intern status
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE interns i JOIN internship_applications a ON a.intern_id=i.id " +
                        "SET i.status='APPROVED' WHERE a.id=?")) {
                    ps.setLong(1, appId);
                    ps.executeUpdate();
                }
                // 3. update document status
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE documents d JOIN internship_applications a ON a.intern_id=d.intern_id " +
                        "SET d.status='APPROVED', d.reviewed_by=?, d.reviewed_at=NOW() " +
                        "WHERE a.id=? AND d.document_type='INTERNSHIP_APPLICATION'")) {
                    ps.setLong(1, reviewerId);
                    ps.setLong(2, appId);
                    ps.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Reject an application:
     * - Updates internship_applications.status → REJECTED with reason
     * - Updates interns.status → REJECTED
     * - Updates documents (INTERNSHIP_APPLICATION) → REJECTED
     */
    public boolean reject(Long appId, Long reviewerId, String reason) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE internship_applications SET status='REJECTED', reviewed_by=?, reviewed_at=NOW(), rejection_reason=? WHERE id=?")) {
                    ps.setLong(1, reviewerId);
                    ps.setString(2, reason == null ? "" : reason);
                    ps.setLong(3, appId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE interns i JOIN internship_applications a ON a.intern_id=i.id " +
                        "SET i.status='REJECTED' WHERE a.id=?")) {
                    ps.setLong(1, appId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE documents d JOIN internship_applications a ON a.intern_id=d.intern_id " +
                        "SET d.status='REJECTED', d.reviewed_by=?, d.reviewed_at=NOW() " +
                        "WHERE a.id=? AND d.document_type='INTERNSHIP_APPLICATION'")) {
                    ps.setLong(1, reviewerId);
                    ps.setLong(2, appId);
                    ps.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Get a single application (for email sending after approve/reject). */
    public Application findById(Long id) {
        String sql =
            "SELECT a.*, i.student_code, i.university, i.major, " +
            "       COALESCE(u.full_name, i.email) AS intern_name, COALESCE(u.email, i.email) AS intern_email, " +
            "       ru.full_name AS reviewer_name " +
            "FROM internship_applications a " +
            "JOIN interns i ON a.intern_id = i.id " +
            "LEFT JOIN users u   ON i.user_id   = u.id " +
            "LEFT JOIN users ru ON a.reviewed_by = ru.id " +
            "WHERE a.id = ?";
        List<Application> result = query(sql, id);
        return result.isEmpty() ? null : result.get(0);
    }

    // ── helpers ─────────────────────────────────────────────────────

    private List<Application> query(String sql, Object... args) {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < args.length; i++) ps.setObject(i + 1, args[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getLong("id"));
        a.setInternId(rs.getLong("intern_id"));
        a.setStudentCode(rs.getString("student_code"));
        a.setUniversity(rs.getString("university"));
        a.setMajor(rs.getString("major"));
        a.setInternName(rs.getString("intern_name"));
        a.setInternEmail(rs.getString("intern_email"));
        a.setStatus(rs.getString("status"));
        a.setRejectionReason(rs.getString("rejection_reason"));
        Timestamp appDate = rs.getTimestamp("application_date");
        if (appDate != null) a.setApplicationDate(appDate.toLocalDateTime());
        try { a.setReviewedBy(rs.getLong("reviewed_by")); } catch (Exception ignored) {}
        try { a.setReviewerName(rs.getString("reviewer_name")); } catch (Exception ignored) {}
        Timestamp revAt = rs.getTimestamp("reviewed_at");
        if (revAt != null) a.setReviewedAt(revAt.toLocalDateTime());
        return a;
    }
}
