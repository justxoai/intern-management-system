package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * HR — End-of-Term Report. (#3 HR user story: synthesize evaluations into report)
 *
 * GET /hr/report — generates a comprehensive per-intern report:
 *   intern info, mentor name, task stats, contract status, document status.
 *
 * Supports filters: internStatus, university, major
 */
@WebServlet("/hr/report")
public class HrReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filterStatus     = nullToEmpty(request.getParameter("internStatus"));
        String filterUniversity = nullToEmpty(request.getParameter("university"));
        String filterMajor      = nullToEmpty(request.getParameter("major"));

        List<Map<String, Object>> reportRows = buildReport(filterStatus, filterUniversity, filterMajor);

        // Aggregate totals for summary strip
        int totalInterns   = reportRows.size();
        long totalTasks    = reportRows.stream().mapToLong(r -> toLong(r.get("totalTasks"))).sum();
        long doneTasks     = reportRows.stream().mapToLong(r -> toLong(r.get("completedTasks"))).sum();
        long activeInterns = reportRows.stream().filter(r -> "INTERNING".equals(r.get("internStatus"))).count();

        // Evaluation stats
        long evaluatedInterns = reportRows.stream().filter(r -> r.get("overallScore") != null).count();
        double sumOverall = reportRows.stream()
                .filter(r -> r.get("overallScore") != null)
                .mapToDouble(r -> ((Number) r.get("overallScore")).doubleValue()).sum();
        double avgOverallScore = evaluatedInterns > 0 ? Math.round((sumOverall / evaluatedInterns) * 10.0) / 10.0 : 0.0;

        request.setAttribute("reportRows",       reportRows);
        request.setAttribute("totalInterns",     totalInterns);
        request.setAttribute("totalTasks",       totalTasks);
        request.setAttribute("doneTasks",        doneTasks);
        request.setAttribute("activeInterns",    activeInterns);
        request.setAttribute("evaluatedInterns", evaluatedInterns);
        request.setAttribute("avgOverallScore",  avgOverallScore);
        request.setAttribute("filterStatus",     filterStatus);
        request.setAttribute("filterUniversity", filterUniversity);
        request.setAttribute("filterMajor",      filterMajor);

        request.getRequestDispatcher("/WEB-INF/views/hr/report.jsp").forward(request, response);
    }

    /**
     * One query per intern is expensive; use a single aggregate SQL instead.
     */
    private List<Map<String, Object>> buildReport(String status, String university, String major) {
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "  i.id             AS intern_id, " +
            "  i.student_code, " +
            "  i.university, " +
            "  i.major, " +
            "  i.status         AS intern_status, " +
            "  i.created_at     AS enrolled_at, " +
            "  u.full_name      AS intern_name, " +
            "  u.email          AS intern_email, " +
            "  u.phone          AS intern_phone, " +
            "  mu.full_name     AS mentor_name, " +
            "  COUNT(DISTINCT t.id)                                          AS total_tasks, " +
            "  SUM(CASE WHEN t.status = 'COMPLETED'  THEN 1 ELSE 0 END)     AS completed_tasks, " +
            "  SUM(CASE WHEN t.status = 'IN_PROGRESS' THEN 1 ELSE 0 END)    AS inprogress_tasks, " +
            "  COALESCE(AVG(t.progress), 0)                                  AS avg_progress, " +
            "  c.status         AS contract_status, " +
            "  c.start_date, " +
            "  c.end_date, " +
            "  SUM(CASE WHEN d.document_type='CV'                    AND d.status='APPROVED' THEN 1 ELSE 0 END) AS cv_ok, " +
            "  SUM(CASE WHEN d.document_type='INTERNSHIP_APPLICATION' AND d.status='APPROVED' THEN 1 ELSE 0 END) AS app_ok, " +
            "  e.technical_score, " +
            "  e.attitude_score, " +
            "  e.communication_score, " +
            "  e.overall_score, " +
            "  e.comments       AS mentor_comments, " +
            "  e.evaluated_at " +
            "FROM interns i " +
            "JOIN  users u   ON i.user_id    = u.id " +
            "LEFT JOIN mentor_assignments ma ON ma.intern_id = i.id AND ma.status = 'ACTIVE' " +
            "LEFT JOIN mentors m   ON m.id  = ma.mentor_id " +
            "LEFT JOIN users mu    ON mu.id = m.user_id " +
            "LEFT JOIN tasks t     ON t.intern_id = i.id " +
            "LEFT JOIN contracts c ON c.intern_id = i.id " +
            "LEFT JOIN documents d ON d.intern_id = i.id " +
            "LEFT JOIN evaluations e ON e.intern_id = i.id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (!status.isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(status);
        }
        if (!university.isEmpty()) {
            sql.append("AND i.university LIKE ? ");
            params.add("%" + university + "%");
        }
        if (!major.isEmpty()) {
            sql.append("AND i.major LIKE ? ");
            params.add("%" + major + "%");
        }
        sql.append("GROUP BY i.id, c.id, e.id ORDER BY i.id DESC");

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("internId",       rs.getLong("intern_id"));
                    row.put("studentCode",    rs.getString("student_code"));
                    row.put("university",     rs.getString("university"));
                    row.put("major",          rs.getString("major"));
                    row.put("internStatus",   rs.getString("intern_status"));
                    row.put("enrolledAt",     rs.getTimestamp("enrolled_at"));
                    row.put("internName",     rs.getString("intern_name"));
                    row.put("internEmail",    rs.getString("intern_email"));
                    row.put("internPhone",    rs.getString("intern_phone"));
                    row.put("mentorName",     rs.getString("mentor_name"));
                    row.put("totalTasks",     rs.getLong("total_tasks"));
                    row.put("completedTasks", rs.getLong("completed_tasks"));
                    row.put("inprogressTasks",rs.getLong("inprogress_tasks"));
                    double avg = rs.getDouble("avg_progress");
                    row.put("avgProgress",    (int) avg);
                    row.put("contractStatus", rs.getString("contract_status"));
                    row.put("startDate",      rs.getDate("start_date"));
                    row.put("endDate",        rs.getDate("end_date"));
                    row.put("cvOk",           rs.getInt("cv_ok") > 0);
                    row.put("appOk",          rs.getInt("app_ok") > 0);

                    // Evaluation metrics
                    row.put("technicalScore",     rs.getBigDecimal("technical_score"));
                    row.put("attitudeScore",      rs.getBigDecimal("attitude_score"));
                    row.put("communicationScore", rs.getBigDecimal("communication_score"));
                    java.math.BigDecimal overall = rs.getBigDecimal("overall_score");
                    row.put("overallScore",       overall);
                    row.put("mentorComments",     rs.getString("mentor_comments"));
                    row.put("evaluatedAt",        rs.getTimestamp("evaluated_at"));

                    String evalGrade = "Chưa đánh giá";
                    if (overall != null) {
                        double sc = overall.doubleValue();
                        if (sc >= 9.0) evalGrade = "Xuất sắc";
                        else if (sc >= 8.0) evalGrade = "Giỏi";
                        else if (sc >= 6.5) evalGrade = "Khá";
                        else if (sc >= 5.0) evalGrade = "Trung bình";
                        else evalGrade = "Chưa đạt";
                    }
                    row.put("evalGrade", evalGrade);

                    // Compute performance grade based on task completion
                    long total = rs.getLong("total_tasks");
                    long done  = rs.getLong("completed_tasks");
                    double rate = total > 0 ? (done * 100.0 / total) : 0;
                    row.put("completionRate", (int) rate);
                    String grade;
                    if (total == 0)   grade = "N/A";
                    else if (rate >= 90) grade = "Excellent";
                    else if (rate >= 75) grade = "Good";
                    else if (rate >= 50) grade = "Average";
                    else                 grade = "Needs Improvement";
                    row.put("grade", grade);

                    rows.add(row);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return rows;
    }

    private long toLong(Object o) {
        if (o == null) return 0;
        try { return ((Number) o).longValue(); }
        catch (Exception e) { return 0; }
    }

    private String nullToEmpty(String v) { return v == null ? "" : v.trim(); }
}
