package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Mentor;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the 'mentors' table.
 * mentor_assignments.mentor_id → mentors.id (NOT users.id)
 */
public class MentorDAO {

    /**
     * All mentors with their current active intern count.
     * Workload balance view.
     */
    public List<Mentor> findAll(String keyword, String department) {
        StringBuilder sql = new StringBuilder(
            "SELECT m.id, m.user_id, m.department, m.position, m.max_interns, m.created_at, " +
            "       u.full_name, u.email, u.phone, u.status AS user_status, " +
            "       COUNT(ma.id) AS intern_count " +
            "FROM mentors m " +
            "JOIN users u ON m.user_id = u.id " +
            "LEFT JOIN mentor_assignments ma ON ma.mentor_id = m.id AND ma.status = 'ACTIVE' " +
            "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ? OR m.department LIKE ? OR m.position LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (department != null && !department.isBlank()) {
            sql.append("AND m.department LIKE ? ");
            params.add("%" + department.trim() + "%");
        }
        sql.append("GROUP BY m.id ORDER BY m.id DESC");
        return query(sql.toString(), params.toArray());
    }

    public Mentor findById(Long id) {
        String sql =
            "SELECT m.id, m.user_id, m.department, m.position, m.max_interns, m.created_at, " +
            "       u.full_name, u.email, u.phone, u.status AS user_status, " +
            "       COUNT(ma.id) AS intern_count " +
            "FROM mentors m " +
            "JOIN users u ON m.user_id = u.id " +
            "LEFT JOIN mentor_assignments ma ON ma.mentor_id = m.id AND ma.status = 'ACTIVE' " +
            "WHERE m.id = ? GROUP BY m.id";
        List<Mentor> result = query(sql, id);
        return result.isEmpty() ? null : result.get(0);
    }

    public Mentor findByUserId(Long userId) {
        String sql =
            "SELECT m.id, m.user_id, m.department, m.position, m.max_interns, m.created_at, " +
            "       u.full_name, u.email, u.phone, u.status AS user_status, " +
            "       COUNT(ma.id) AS intern_count " +
            "FROM mentors m " +
            "JOIN users u ON m.user_id = u.id " +
            "LEFT JOIN mentor_assignments ma ON ma.mentor_id = m.id AND ma.status = 'ACTIVE' " +
            "WHERE m.user_id = ? GROUP BY m.id";
        List<Mentor> result = query(sql, userId);
        return result.isEmpty() ? null : result.get(0);
    }

    /**
     * Create mentors record for a given user_id (called when MENTOR user is created).
     */
    public boolean insert(Long userId, String department, String position, int maxInterns) {
        String sql = "INSERT INTO mentors (user_id, department, position, max_interns) VALUES (?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE department=VALUES(department), position=VALUES(position), max_interns=VALUES(max_interns)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, department == null ? "" : department);
            ps.setString(3, position == null ? "" : position);
            ps.setInt(4, maxInterns <= 0 ? 5 : maxInterns);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Long mentorId, String department, String position, int maxInterns) {
        String sql = "UPDATE mentors SET department=?, position=?, max_interns=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            ps.setString(2, position);
            ps.setInt(3, maxInterns <= 0 ? 5 : maxInterns);
            ps.setLong(4, mentorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── Mentor Assignments ─────────────────────────────────────────

    /**
     * Assign an intern (interns.id) to a mentor (mentors.id).
     */
    public boolean assign(Long mentorId, Long internId) {
        String updateOldSql = "UPDATE mentor_assignments SET status='ENDED' WHERE intern_id=? AND mentor_id != ?";
        String upsertSql = "INSERT INTO mentor_assignments (mentor_id, intern_id, status) VALUES (?,?,'ACTIVE') " +
                           "ON DUPLICATE KEY UPDATE status='ACTIVE'";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement(updateOldSql)) {
                ps1.setLong(1, internId);
                ps1.setLong(2, mentorId);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(upsertSql)) {
                ps2.setLong(1, mentorId);
                ps2.setLong(2, internId);
                return ps2.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean unassign(Long mentorId, Long internId) {
        String sql = "UPDATE mentor_assignments SET status='ENDED' WHERE mentor_id=? AND intern_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, mentorId); ps.setLong(2, internId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── helpers ────────────────────────────────────────────────────

    private List<Mentor> query(String sql, Object... args) {
        List<Mentor> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < args.length; i++) ps.setObject(i + 1, args[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Mentor mapRow(ResultSet rs) throws SQLException {
        Mentor m = new Mentor();
        m.setId(rs.getLong("id"));
        m.setUserId(rs.getLong("user_id"));
        m.setDepartment(rs.getString("department"));
        m.setPosition(rs.getString("position"));
        m.setMaxInterns(rs.getInt("max_interns"));
        m.setCurrentInternCount(rs.getInt("intern_count"));
        m.setFullName(rs.getString("full_name"));
        m.setEmail(rs.getString("email"));
        m.setPhone(rs.getString("phone"));
        m.setUserStatus(rs.getString("user_status"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) m.setCreatedAt(ca.toLocalDateTime());
        return m;
    }
}
