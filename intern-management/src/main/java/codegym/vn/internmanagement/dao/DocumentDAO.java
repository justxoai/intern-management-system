package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Document;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the 'documents' table.
 */
public class DocumentDAO {

    /** All documents for a given intern (ordered newest first). */
    public List<Document> findByInternId(Long internId) {
        String sql = "SELECT d.*, u.full_name AS intern_name, rv.full_name AS reviewer_name " +
                     "FROM documents d " +
                     "JOIN interns i ON d.intern_id = i.id " +
                     "JOIN users u ON i.user_id = u.id " +
                     "LEFT JOIN users rv ON d.reviewed_by = rv.id " +
                     "WHERE d.intern_id = ? ORDER BY d.uploaded_at DESC";
        return query(sql, internId);
    }

    /** All documents across all interns — for HR view, with optional status filter. */
    public List<Document> findAll(String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, u.full_name AS intern_name, rv.full_name AS reviewer_name " +
            "FROM documents d " +
            "JOIN interns i ON d.intern_id = i.id " +
            "JOIN users u ON i.user_id = u.id " +
            "LEFT JOIN users rv ON d.reviewed_by = rv.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isBlank()) {
            sql.append(" AND d.status = ?");
            params.add(statusFilter);
        }
        sql.append(" ORDER BY d.uploaded_at DESC");

        List<Document> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Insert a new document record. */
    public boolean insert(Document doc) {
        String sql = "INSERT INTO documents (intern_id, document_type, file_name, file_path, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, doc.getInternId());
            ps.setString(2, doc.getDocumentType());
            ps.setString(3, doc.getFileName());
            ps.setString(4, doc.getFilePath());
            ps.setString(5, "PENDING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Approve or reject a document; records the reviewing HR user. */
    public boolean updateStatus(Long docId, String newStatus, Long reviewedByUserId) {
        String sql = "UPDATE documents SET status=?, reviewed_by=?, reviewed_at=NOW() WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, reviewedByUserId);
            ps.setLong(3, docId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Delete a document record (intern can delete their own pending docs). */
    public boolean delete(Long id) {
        String sql = "DELETE FROM documents WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── helpers ────────────────────────────────────────────────

    private List<Document> query(String sql, Object... args) {
        List<Document> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < args.length; i++) ps.setObject(i + 1, args[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Document mapRow(ResultSet rs) throws SQLException {
        Document d = new Document();
        d.setId(rs.getLong("id"));
        d.setInternId(rs.getLong("intern_id"));
        d.setDocumentType(rs.getString("document_type"));
        d.setFileName(rs.getString("file_name"));
        d.setFilePath(rs.getString("file_path"));
        d.setStatus(rs.getString("status"));
        d.setReviewedBy(rs.getLong("reviewed_by"));
        Timestamp rev = rs.getTimestamp("reviewed_at");
        if (rev != null) d.setReviewedAt(rev.toLocalDateTime());
        Timestamp upl = rs.getTimestamp("uploaded_at");
        if (upl != null) d.setUploadedAt(upl.toLocalDateTime());
        try { d.setInternName(rs.getString("intern_name")); }   catch (SQLException ignored) {}
        try { d.setReviewerName(rs.getString("reviewer_name")); } catch (SQLException ignored) {}
        return d;
    }
}
