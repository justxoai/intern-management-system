package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * HR Dashboard: shows Intern section + Mentor section.
 * GET /hr/dashboard
 */
@WebServlet("/hr/dashboard")
public class HrDashboardServlet extends HttpServlet {

    private UserModel userModel;
    private InternDAO internDAO;

    @Override
    public void init() {
        userModel = new UserModel();
        internDAO = new InternDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ---- Intern section filters ----
        String internKeyword    = nullToEmpty(request.getParameter("internKeyword"));
        String internUniversity = nullToEmpty(request.getParameter("internUniversity"));
        String internMajor      = nullToEmpty(request.getParameter("internMajor"));
        String internStatus     = nullToEmpty(request.getParameter("internStatus"));

        List<Intern> interns = internDAO.search(
                internKeyword.isEmpty()    ? null : internKeyword,
                internUniversity.isEmpty() ? null : internUniversity,
                internMajor.isEmpty()      ? null : internMajor,
                internStatus.isEmpty()     ? null : internStatus
        );

        // ---- Mentor section filters ----
        String mentorId    = nullToEmpty(request.getParameter("mentorId"));
        String mentorName  = nullToEmpty(request.getParameter("mentorName"));
        String mentorEmail = nullToEmpty(request.getParameter("mentorEmail"));
        String mentorPhone = nullToEmpty(request.getParameter("mentorPhone"));
        String mentorStatus = nullToEmpty(request.getParameter("mentorStatus"));

        List<User> allUsers = userModel.searchAdminUsers("");
        List<User> mentors = allUsers.stream()
                .filter(u -> "MENTOR".equalsIgnoreCase(u.getRole()))
                .filter(u -> mentorId.isEmpty()     || String.valueOf(u.getId()).contains(mentorId))
                .filter(u -> mentorName.isEmpty()   || containsIgnoreCase(u.getFullName(), mentorName))
                .filter(u -> mentorEmail.isEmpty()  || containsIgnoreCase(u.getEmail(), mentorEmail))
                .filter(u -> mentorPhone.isEmpty()  || containsIgnoreCase(u.getPhone(), mentorPhone))
                .filter(u -> mentorStatus.isEmpty() || mentorStatus.equalsIgnoreCase(u.getStatus()))
                .collect(Collectors.toList());

        // Pass filter state
        request.setAttribute("internKeyword",    internKeyword);
        request.setAttribute("internUniversity", internUniversity);
        request.setAttribute("internMajor",      internMajor);
        request.setAttribute("internStatus",     internStatus);
        request.setAttribute("mentorId",         mentorId);
        request.setAttribute("mentorName",       mentorName);
        request.setAttribute("mentorEmail",      mentorEmail);
        request.setAttribute("mentorPhone",      mentorPhone);
        request.setAttribute("mentorStatus",     mentorStatus);

        request.setAttribute("interns", interns);
        request.setAttribute("mentors", mentors);

        request.getRequestDispatcher("/WEB-INF/views/hr/dashboard.jsp")
                .forward(request, response);
    }

    private String nullToEmpty(String val) {
        return val == null ? "" : val.trim();
    }

    private boolean containsIgnoreCase(String src, String q) {
        return src != null && src.toLowerCase().contains(q.toLowerCase());
    }
}
