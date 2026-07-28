package codegym.vn.internmanagement.controller.admin;

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
 * Controller handling user list viewing for ADMIN.
 * GET /admin/users
 * Supports per-section filtering (hrName, mentorName, internId, etc.)
 */
@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {

    private UserModel userModel;

    @Override
    public void init() {
        userModel = new UserModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch all users (join with interns for intern fields)
        List<User> allUsers = userModel.searchAdminUsers("");

        // ---- HR filters ----
        String hrId     = nullToEmpty(request.getParameter("hrId"));
        String hrName   = nullToEmpty(request.getParameter("hrName"));
        String hrEmail  = nullToEmpty(request.getParameter("hrEmail"));
        String hrPhone  = nullToEmpty(request.getParameter("hrPhone"));
        String hrStatus = nullToEmpty(request.getParameter("hrStatus"));

        List<User> hrUsers = allUsers.stream()
                .filter(u -> "HR".equalsIgnoreCase(u.getRole()))
                .filter(u -> hrId.isEmpty()     || String.valueOf(u.getId()).contains(hrId))
                .filter(u -> hrName.isEmpty()   || containsIgnoreCase(u.getFullName(), hrName))
                .filter(u -> hrEmail.isEmpty()  || containsIgnoreCase(u.getEmail(), hrEmail))
                .filter(u -> hrPhone.isEmpty()  || containsIgnoreCase(u.getPhone(), hrPhone))
                .filter(u -> hrStatus.isEmpty() || hrStatus.equalsIgnoreCase(u.getStatus()))
                .collect(Collectors.toList());

        // ---- Mentor filters ----
        String mentorId     = nullToEmpty(request.getParameter("mentorId"));
        String mentorName   = nullToEmpty(request.getParameter("mentorName"));
        String mentorEmail  = nullToEmpty(request.getParameter("mentorEmail"));
        String mentorPhone  = nullToEmpty(request.getParameter("mentorPhone"));
        String mentorStatus = nullToEmpty(request.getParameter("mentorStatus"));

        List<User> mentorUsers = allUsers.stream()
                .filter(u -> "MENTOR".equalsIgnoreCase(u.getRole()))
                .filter(u -> mentorId.isEmpty()     || String.valueOf(u.getId()).contains(mentorId))
                .filter(u -> mentorName.isEmpty()   || containsIgnoreCase(u.getFullName(), mentorName))
                .filter(u -> mentorEmail.isEmpty()  || containsIgnoreCase(u.getEmail(), mentorEmail))
                .filter(u -> mentorPhone.isEmpty()  || containsIgnoreCase(u.getPhone(), mentorPhone))
                .filter(u -> mentorStatus.isEmpty() || mentorStatus.equalsIgnoreCase(u.getStatus()))
                .collect(Collectors.toList());

        // ---- Intern filters ----
        String internId         = nullToEmpty(request.getParameter("internId"));
        String internName       = nullToEmpty(request.getParameter("internName"));
        String internEmail      = nullToEmpty(request.getParameter("internEmail"));
        String internPhone      = nullToEmpty(request.getParameter("internPhone"));
        String internMajor      = nullToEmpty(request.getParameter("internMajor"));
        String internUniversity = nullToEmpty(request.getParameter("internUniversity"));

        List<User> internUsers = allUsers.stream()
                .filter(u -> "INTERN".equalsIgnoreCase(u.getRole()))
                .filter(u -> internId.isEmpty()   || String.valueOf(u.getId()).contains(internId)
                                                  || containsIgnoreCase(u.getStudentCode(), internId))
                .filter(u -> internName.isEmpty()       || containsIgnoreCase(u.getFullName(), internName))
                .filter(u -> internEmail.isEmpty()      || containsIgnoreCase(u.getEmail(), internEmail))
                .filter(u -> internPhone.isEmpty()      || containsIgnoreCase(u.getPhone(), internPhone))
                .filter(u -> internMajor.isEmpty()      || containsIgnoreCase(u.getMajor(), internMajor))
                .filter(u -> internUniversity.isEmpty() || containsIgnoreCase(u.getUniversity(), internUniversity))
                .collect(Collectors.toList());

        // Pass filter values back to JSP for form state persistence
        request.setAttribute("hrId",     hrId);
        request.setAttribute("hrName",   hrName);
        request.setAttribute("hrEmail",  hrEmail);
        request.setAttribute("hrPhone",  hrPhone);
        request.setAttribute("hrStatus", hrStatus);

        request.setAttribute("mentorId",     mentorId);
        request.setAttribute("mentorName",   mentorName);
        request.setAttribute("mentorEmail",  mentorEmail);
        request.setAttribute("mentorPhone",  mentorPhone);
        request.setAttribute("mentorStatus", mentorStatus);

        request.setAttribute("internId",         internId);
        request.setAttribute("internName",       internName);
        request.setAttribute("internEmail",      internEmail);
        request.setAttribute("internPhone",      internPhone);
        request.setAttribute("internMajor",      internMajor);
        request.setAttribute("internUniversity", internUniversity);

        request.setAttribute("hrUsers",     hrUsers);
        request.setAttribute("mentorUsers", mentorUsers);
        request.setAttribute("internUsers", internUsers);

        request.getRequestDispatcher("/WEB-INF/views/admin/users/list.jsp")
                .forward(request, response);
    }

    private String nullToEmpty(String val) {
        return val == null ? "" : val.trim();
    }

    private boolean containsIgnoreCase(String src, String query) {
        if (src == null) return false;
        return src.toLowerCase().contains(query.toLowerCase());
    }
}
