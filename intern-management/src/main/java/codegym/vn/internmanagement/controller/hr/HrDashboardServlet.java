package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * HR Dashboard — hiển thị danh sách intern và mentor.
 *
 * GET /hr/dashboard
 *
 * Hỗ trợ filter:
 *   Intern  : internKeyword, internUniversity, internMajor, internStatus
 *   Mentor  : mentorId, mentorName, mentorEmail, mentorPhone, mentorStatus
 */
@WebServlet("/hr/dashboard")
public class HrDashboardServlet extends HttpServlet {

    private InternDAO internDAO;
    private MentorDAO mentorDAO;

    @Override
    public void init() {
        internDAO = new InternDAO();
        mentorDAO = new MentorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Intern filters ──────────────────────────────────────
        String internKeyword    = nullToEmpty(request.getParameter("internKeyword"));
        String internUniversity = nullToEmpty(request.getParameter("internUniversity"));
        String internMajor      = nullToEmpty(request.getParameter("internMajor"));
        String internStatus     = nullToEmpty(request.getParameter("internStatus"));

        List<Intern> interns = internDAO.search(
                internKeyword.isEmpty()    ? null : internKeyword,
                internUniversity.isEmpty() ? null : internUniversity,
                internMajor.isEmpty()      ? null : internMajor,
                internStatus.isEmpty()     ? null : internStatus);

        // ── Mentor filters ──────────────────────────────────────
        String mentorId     = nullToEmpty(request.getParameter("mentorId"));
        String mentorName   = nullToEmpty(request.getParameter("mentorName"));
        String mentorEmail  = nullToEmpty(request.getParameter("mentorEmail"));
        String mentorPhone  = nullToEmpty(request.getParameter("mentorPhone"));
        String mentorStatus = nullToEmpty(request.getParameter("mentorStatus"));

        // Dùng keyword tổng hợp từ name/email, department làm keyword2
        String mentorKeyword = buildMentorKeyword(mentorId, mentorName, mentorEmail, mentorPhone);
        List<Mentor> mentors = mentorDAO.findAll(
                mentorKeyword.isEmpty() ? null : mentorKeyword,
                null);

        // Lọc thêm theo status phía Java (nếu có)
        if (!mentorStatus.isEmpty()) {
            mentors = mentors.stream()
                    .filter(m -> mentorStatus.equalsIgnoreCase(m.getUserStatus()))
                    .toList();
        }

        // ── Pass attributes ─────────────────────────────────────
        request.setAttribute("interns",          interns);
        request.setAttribute("mentors",          mentors);

        request.setAttribute("internKeyword",    internKeyword);
        request.setAttribute("internUniversity", internUniversity);
        request.setAttribute("internMajor",      internMajor);
        request.setAttribute("internStatus",     internStatus);

        request.setAttribute("mentorId",         mentorId);
        request.setAttribute("mentorName",       mentorName);
        request.setAttribute("mentorEmail",      mentorEmail);
        request.setAttribute("mentorPhone",      mentorPhone);
        request.setAttribute("mentorStatus",     mentorStatus);

        request.getRequestDispatcher("/WEB-INF/views/hr/dashboard.jsp")
                .forward(request, response);
    }

    /** Ghép các filter mentor thành một keyword tìm kiếm duy nhất */
    private String buildMentorKeyword(String id, String name, String email, String phone) {
        // Ưu tiên id nếu có
        if (!id.isEmpty()) return id;
        // Dùng field đầu tiên không rỗng
        if (!name.isEmpty())  return name;
        if (!email.isEmpty()) return email;
        if (!phone.isEmpty()) return phone;
        return "";
    }

    private String nullToEmpty(String v) {
        return v == null ? "" : v.trim();
    }
}
