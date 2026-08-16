package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Contract;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the 'contracts' table.
 */
public class ContractDAO {

    /** All contracts (HR view) with optional status filter. */
    public List<Contract> findAll(String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, i.student_code, COALESCE(u.full_name, i.email) AS intern_name, d.file_name, d.file_path " +
            "FROM contracts c " +
            "JOIN interns i ON c.intern_id = i.id " +
            "LEFT JOIN users u ON i.user_id = u.id " +
            "LEFT JOIN documents d ON c.document_id = d.id " +
            "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isBlank()) {
            sql.append(" AND c.status = ?");
            params.add(statusFilter);
        }
        sql.append(" ORDER BY c.id DESC");
        return query(sql.toString(), params.toArray());
    }

    /** All contracts for a specific intern (intern view). */
    public List<Contract> findByInternId(Long internId) {
        String sql =
            "SELECT c.*, i.student_code, COALESCE(u.full_name, i.email) AS intern_name, d.file_name, d.file_path " +
            "FROM contracts c " +
            "JOIN interns i ON c.intern_id = i.id " +
            "LEFT JOIN users u ON i.user_id = u.id " +
            "LEFT JOIN documents d ON c.document_id = d.id " +
            "WHERE c.intern_id = ? ORDER BY c.id DESC";
        return query(sql, internId);
    }

    /**
     * Insert a new contract record.
     * Returns the generated ID, or -1 on failure.
     */
    public long insert(Contract contract) {
        String sql = "INSERT INTO contracts (intern_id, document_id, start_date, end_date, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, contract.getInternId());
            ps.setObject(2, contract.getDocumentId());
            ps.setDate(3, contract.getStartDate() != null ? Date.valueOf(contract.getStartDate()) : null);
            ps.setDate(4, contract.getEndDate() != null ? Date.valueOf(contract.getEndDate()) : null);
            ps.setString(5, "PENDING");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    /** Intern confirms contract → status = CONFIRMED. Also updates document status to APPROVED. */
    public boolean confirm(Long contractId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE contracts SET status='CONFIRMED', confirmed_at=NOW() WHERE id=? AND status='PENDING'")) {
                    ps.setLong(1, contractId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE documents d JOIN contracts c ON c.document_id = d.id SET d.status='APPROVED' WHERE c.id=?")) {
                    ps2.setLong(1, contractId);
                    ps2.executeUpdate();
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

    /** HR cancels a contract. Also updates document status to REJECTED. */
    public boolean cancel(Long contractId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE contracts SET status='CANCELLED' WHERE id=?")) {
                    ps.setLong(1, contractId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE documents d JOIN contracts c ON c.document_id = d.id SET d.status='REJECTED' WHERE c.id=?")) {
                    ps2.setLong(1, contractId);
                    ps2.executeUpdate();
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

    // ── helpers ──────────────────────────────────────────────────

    private List<Contract> query(String sql, Object... args) {
        List<Contract> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < args.length; i++) ps.setObject(i + 1, args[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Contract mapRow(ResultSet rs) throws SQLException {
        Contract c = new Contract();
        c.setId(rs.getLong("id"));
        c.setInternId(rs.getLong("intern_id"));
        c.setDocumentId(rs.getLong("document_id"));
        Date sd = rs.getDate("start_date");
        if (sd != null) c.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) c.setEndDate(ed.toLocalDate());
        c.setStatus(rs.getString("status"));
        Timestamp conf = rs.getTimestamp("confirmed_at");
        if (conf != null) c.setConfirmedAt(conf.toLocalDateTime());
        try { c.setInternName(rs.getString("intern_name")); }  catch (SQLException ignored) {}
        try { c.setStudentCode(rs.getString("student_code")); } catch (SQLException ignored) {}
        try { c.setFileName(rs.getString("file_name")); }       catch (SQLException ignored) {}
        try { c.setFilePath(rs.getString("file_path")); }       catch (SQLException ignored) {}
        return c;
    }
}
