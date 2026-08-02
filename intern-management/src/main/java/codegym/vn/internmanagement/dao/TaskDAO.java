package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Task;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for tasks table.
 * Note: tasks.mentor_id references mentors.id (not users.id).
 * Use mentorUserId (users.id) and join through mentors to find mentor record.
 */
public class TaskDAO {

    /**
     * Find all tasks for a mentor, using their user_id to resolve mentors.id.
     */
    public List<Task> findByMentorUserId(Long mentorUserId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name AS intern_name " +
                     "FROM tasks t " +
                     "JOIN mentors m ON t.mentor_id = m.id " +
                     "LEFT JOIN interns i ON t.intern_id = i.id " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "WHERE m.user_id = ? ORDER BY t.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, mentorUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Task findById(Long id) {
        String sql = "SELECT t.*, u.full_name AS intern_name " +
                     "FROM tasks t " +
                     "LEFT JOIN interns i ON t.intern_id = i.id " +
                     "LEFT JOIN users u ON i.user_id = u.id " +
                     "WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Insert a task. mentorsId = mentors.id (NOT users.id).
     */
    public boolean insert(Task task) {
        String sql = "INSERT INTO tasks (title, description, intern_id, mentor_id, status, start_date, due_date) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setObject(3, task.getInternId());
            ps.setObject(4, task.getMentorId());
            ps.setString(5, task.getStatus() != null ? task.getStatus() : "TODO");
            ps.setObject(6, task.getDueDate() != null ? Date.valueOf(task.getDueDate()) : null);
            ps.setObject(7, task.getDueDate() != null ? Date.valueOf(task.getDueDate()) : null);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Task task) {
        String sql = "UPDATE tasks SET title=?, description=?, intern_id=?, status=?, due_date=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setObject(3, task.getInternId());
            ps.setString(4, task.getStatus());
            ps.setObject(5, task.getDueDate() != null ? Date.valueOf(task.getDueDate()) : null);
            ps.setLong(6, task.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM tasks WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Resolve a user's mentor record ID (mentors.id) from their users.id.
     * Returns null if no mentor record found.
     */
    public Long findMentorIdByUserId(Long userId) {
        String sql = "SELECT id FROM mentors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Task mapRow(ResultSet rs) throws SQLException {
        Task t = new Task();
        t.setId(rs.getLong("id"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setInternId(rs.getLong("intern_id"));
        t.setMentorId(rs.getLong("mentor_id"));
        t.setStatus(rs.getString("status"));
        Date due = rs.getDate("due_date");
        if (due != null) t.setDueDate(due.toLocalDate());
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) t.setCreatedAt(created.toLocalDateTime());
        try { t.setInternName(rs.getString("intern_name")); } catch (SQLException ignored) {}
        return t;
    }
}
