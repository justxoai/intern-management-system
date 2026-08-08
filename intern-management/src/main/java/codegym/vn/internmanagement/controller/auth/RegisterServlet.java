package codegym.vn.internmanagement.controller.auth;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;
import codegym.vn.internmanagement.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Public registration page for interns.
 * GET  /register — show form
 * POST /register — create user + intern profile + internship application
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserModel userModel;
    private UserDAO   userDAO;
    private InternDAO internDAO;

    @Override
    public void init() {
        userModel = new UserModel();
        userDAO   = new UserDAO();
        internDAO = new InternDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Collect form data ---
        String username    = trim(request.getParameter("username"));
        String password    = trim(request.getParameter("password"));
        String confirm     = trim(request.getParameter("confirmPassword"));
        String fullName    = trim(request.getParameter("fullName"));
        String email       = trim(request.getParameter("email"));
        String phone       = trim(request.getParameter("phone"));
        String studentCode = trim(request.getParameter("studentCode"));
        String university  = trim(request.getParameter("university"));
        String major       = trim(request.getParameter("major"));
        String dobStr      = trim(request.getParameter("dateOfBirth"));
        String gender      = trim(request.getParameter("gender"));
        String address     = trim(request.getParameter("address"));

        // --- Basic validation ---
        if (!password.equals(confirm)) {
            error(request, response, "Passwords do not match.", username, fullName, email);
            return;
        }
        if (university.isEmpty() || major.isEmpty()) {
            error(request, response, "University and Major are required.", username, fullName, email);
            return;
        }

        // --- Build User ---
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);   // UserModel will hash it
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("INTERN");

        String err = userModel.createUser(user);
        if (err != null) {
            error(request, response, err, username, fullName, email);
            return;
        }

        // Retrieve the new user to get generated ID
        User created = userDAO.findByUsername(username);
        if (created == null) {
            error(request, response, "Registration failed. Please try again.", username, fullName, email);
            return;
        }

        // --- Build Intern profile ---
        Intern intern = new Intern();
        intern.setUserId(created.getId());
        intern.setStudentCode(studentCode);
        intern.setUniversity(university);
        intern.setMajor(major);
        intern.setGender(gender.isEmpty() ? null : gender);
        intern.setAddress(address);
        intern.setPhone(phone);
        intern.setEmail(email);
        if (!dobStr.isEmpty()) {
            try { intern.setDateOfBirth(LocalDate.parse(dobStr)); } catch (Exception ignored) {}
        }
        internDAO.insert(intern);

        // --- Create internship application record ---
        Intern saved = internDAO.findByUserId(created.getId());
        if (saved != null) {
            insertApplication(saved.getId());
        }

        // --- Redirect to login with success ---
        response.sendRedirect(request.getContextPath() + "/login?registered=1");
    }

    // ── helpers ──────────────────────────────────────────────────

    private void insertApplication(Long internId) {
        String sql = "INSERT INTO internship_applications (intern_id, status) VALUES (?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, internId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private void error(HttpServletRequest req, HttpServletResponse res, String msg,
                       String username, String fullName, String email)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.setAttribute("username", username);
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, res);
    }

    private String trim(String val) { return val == null ? "" : val.trim(); }
}
