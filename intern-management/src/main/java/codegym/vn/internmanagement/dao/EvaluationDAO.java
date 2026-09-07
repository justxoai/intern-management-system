package codegym.vn.internmanagement.dao;

import codegym.vn.internmanagement.entity.Evaluation;
import codegym.vn.internmanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluationDAO {

    public Evaluation findByInternId(Long internId) {
        String sql = "SELECT e.*, iu.full_name AS intern_name, i.student_code, i.university, i.major, " +
                     "iu.email AS intern_email, iu.phone AS intern_phone, " +
                     "mu.full_name AS mentor_name, mu.email AS mentor_email, m.department " +
                     "FROM evaluations e " +
                     "JOIN interns i ON e.intern_id = i.id " +
                     "JOIN users iu ON i.user_id = iu.id " +
                     "JOIN mentors m ON e.mentor_id = m.id " +
                     "JOIN users mu ON m.user_id = mu.id " +
                     "WHERE e.intern_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, internId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Evaluation> findByMentorUserId(Long mentorUserId) {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, iu.full_name AS intern_name, i.student_code, i.university, i.major, " +
                     "iu.email AS intern_email, iu.phone AS intern_phone, " +
                     "mu.full_name AS mentor_name, mu.email AS mentor_email, m.department " +
                     "FROM evaluations e " +
                     "JOIN interns i ON e.intern_id = i.id " +
                     "JOIN users iu ON i.user_id = iu.id " +
                     "JOIN mentors m ON e.mentor_id = m.id " +
                     "JOIN users mu ON m.user_id = mu.id " +
                     "WHERE m.user_id = ? " +
                     "ORDER BY e.evaluated_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, mentorUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Evaluation> findAllWithDetails() {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, iu.full_name AS intern_name, i.student_code, i.university, i.major, " +
                     "iu.email AS intern_email, iu.phone AS intern_phone, " +
                     "mu.full_name AS mentor_name, mu.email AS mentor_email, m.department " +
                     "FROM evaluations e " +
                     "JOIN interns i ON e.intern_id = i.id " +
                     "JOIN users iu ON i.user_id = iu.id " +
                     "JOIN mentors m ON e.mentor_id = m.id " +
                     "JOIN users mu ON m.user_id = mu.id " +
                     "ORDER BY e.evaluated_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveOrUpdate(Evaluation evaluation) {
        String checkSql = "SELECT id FROM evaluations WHERE intern_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setLong(1, evaluation.getInternId());
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    long existingId = rs.getLong("id");
                    String updateSql = "UPDATE evaluations SET mentor_id = ?, technical_score = ?, attitude_score = ?, " +
                                       "communication_score = ?, overall_score = ?, comments = ?, evaluated_at = CURRENT_TIMESTAMP " +
                                       "WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setLong(1, evaluation.getMentorId());
                        updatePs.setBigDecimal(2, evaluation.getTechnicalScore());
                        updatePs.setBigDecimal(3, evaluation.getAttitudeScore());
                        updatePs.setBigDecimal(4, evaluation.getCommunicationScore());
                        updatePs.setBigDecimal(5, evaluation.getOverallScore());
                        updatePs.setString(6, evaluation.getComments());
                        updatePs.setLong(7, existingId);
                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    String insertSql = "INSERT INTO evaluations (intern_id, mentor_id, technical_score, attitude_score, " +
                                       "communication_score, overall_score, comments, evaluated_at) " +
                                       "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                        insertPs.setLong(1, evaluation.getInternId());
                        insertPs.setLong(2, evaluation.getMentorId());
                        insertPs.setBigDecimal(3, evaluation.getTechnicalScore());
                        insertPs.setBigDecimal(4, evaluation.getAttitudeScore());
                        insertPs.setBigDecimal(5, evaluation.getCommunicationScore());
                        insertPs.setBigDecimal(6, evaluation.getOverallScore());
                        insertPs.setString(7, evaluation.getComments());
                        int rows = insertPs.executeUpdate();
                        if (rows > 0) {
                            try (ResultSet keyRs = insertPs.getGeneratedKeys()) {
                                if (keyRs.next()) evaluation.setId(keyRs.getLong(1));
                            }
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Evaluation mapResultSet(ResultSet rs) throws SQLException {
        Evaluation e = new Evaluation();
        e.setId(rs.getLong("id"));
        e.setInternId(rs.getLong("intern_id"));
        e.setMentorId(rs.getLong("mentor_id"));
        e.setTechnicalScore(rs.getBigDecimal("technical_score"));
        e.setAttitudeScore(rs.getBigDecimal("attitude_score"));
        e.setCommunicationScore(rs.getBigDecimal("communication_score"));
        e.setOverallScore(rs.getBigDecimal("overall_score"));
        e.setComments(rs.getString("comments"));
        e.setEvaluatedAt(rs.getTimestamp("evaluated_at"));

        e.setInternName(rs.getString("intern_name"));
        e.setStudentCode(rs.getString("student_code"));
        e.setUniversity(rs.getString("university"));
        e.setMajor(rs.getString("major"));
        e.setInternEmail(rs.getString("intern_email"));
        e.setInternPhone(rs.getString("intern_phone"));
        e.setMentorName(rs.getString("mentor_name"));
        e.setMentorEmail(rs.getString("mentor_email"));
        e.setDepartment(rs.getString("department"));
        return e;
    }
}
