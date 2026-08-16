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
 * Controller handling user list viewing for ADMIN (Account Management).
 * GET /admin/users
 * Supports per-section filtering matching each table header:
 * - HR: Fullname, Email, Phone
 * - Mentor: Fullname, Email, Phone
 * - Intern: Fullname, Email, Phone, Major, University
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

        // Fetch all users (with joined intern details)
        List<User> allUsers = userModel.searchAdminUsers("");

        // ---- HR filters (matching table headers: Fullname, Email, Phone) ----
        String hrName  = nullToEmpty(request.getParameter("hrName"));
        String hrEmail = nullToEmpty(request.getParameter("hrEmail"));
        String hrPhone = nullToEmpty(request.getParameter("hrPhone"));

        List<User> hrUsers = allUsers.stream()
                .filter(u -> "HR".equalsIgnoreCase(u.getRole()))
                .filter(u -> hrName.isEmpty()  || containsIgnoreCase(u.getFullName(), hrName))
                .filter(u -> hrEmail.isEmpty() || containsIgnoreCase(u.getEmail(), hrEmail))
                .filter(u -> hrPhone.isEmpty() || containsIgnoreCase(u.getPhone(), hrPhone))
                .collect(Collectors.toList());

        // ---- Mentor filters (matching table headers: Fullname, Email, Phone) ----
        String mentorName  = nullToEmpty(request.getParameter("mentorName"));
        String mentorEmail = nullToEmpty(request.getParameter("mentorEmail"));
        String mentorPhone = nullToEmpty(request.getParameter("mentorPhone"));

        List<User> mentorUsers = allUsers.stream()
                .filter(u -> "MENTOR".equalsIgnoreCase(u.getRole()))
                .filter(u -> mentorName.isEmpty()  || containsIgnoreCase(u.getFullName(), mentorName))
                .filter(u -> mentorEmail.isEmpty() || containsIgnoreCase(u.getEmail(), mentorEmail))
                .filter(u -> mentorPhone.isEmpty() || containsIgnoreCase(u.getPhone(), mentorPhone))
                .collect(Collectors.toList());

        // ---- Intern filters (matching table headers: Fullname, Email, Phone, Major, University) ----
        String internName       = nullToEmpty(request.getParameter("internName"));
        String internEmail      = nullToEmpty(request.getParameter("internEmail"));
        String internPhone      = nullToEmpty(request.getParameter("internPhone"));
        String internMajor      = nullToEmpty(request.getParameter("internMajor"));
        String internUniversity = nullToEmpty(request.getParameter("internUniversity"));

        List<User> internUsers = allUsers.stream()
                .filter(u -> "INTERN".equalsIgnoreCase(u.getRole()))
                .filter(u -> internName.isEmpty()       || containsIgnoreCase(u.getFullName(), internName))
                .filter(u -> internEmail.isEmpty()      || containsIgnoreCase(u.getEmail(), internEmail))
                .filter(u -> internPhone.isEmpty()      || containsIgnoreCase(u.getPhone(), internPhone))
                .filter(u -> internMajor.isEmpty()      || containsIgnoreCase(u.getMajor(), internMajor))
                .filter(u -> internUniversity.isEmpty() || containsIgnoreCase(u.getUniversity(), internUniversity))
                .collect(Collectors.toList());

        // Pass filter values back to JSP for state persistence
        request.setAttribute("hrName",  hrName);
        request.setAttribute("hrEmail", hrEmail);
        request.setAttribute("hrPhone", hrPhone);

        request.setAttribute("mentorName",  mentorName);
        request.setAttribute("mentorEmail", mentorEmail);
        request.setAttribute("mentorPhone", mentorPhone);

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
