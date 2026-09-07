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
import java.util.regex.Pattern;

/**
 * Public registration page for interns.
 * GET  /register — show form
 * POST /register — create user + intern profile + internship application
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    // Đầu số hợp lệ VN: 03x, 05x (56-9), 07x (06,7,8,9), 08x, 09x — tổng 10 số
    // hoặc +84 + 9 số bắt đầu bằng các đầu số trên
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^(?:\\+84|0)(3[2-9]|5[6-9]|7[06-9]|8[0-9]|9[0-9])\\d{7}$");

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

        // Helper to forward with preserved fields
        FormData data = new FormData(username, fullName, email, phone, studentCode, university, major, dobStr, gender);

        // --- Validation ---
        if (username.isEmpty()) {
            error(request, response, "Username is required.", data);
            return;
        }
        if (fullName.isEmpty()) {
            error(request, response, "Full Name is required.", data);
            return;
        }

        // Password requirements: 1 Upper, 1 Normal, 1 Number, 1 Special Key, min 6 chars
        if (password.isEmpty()) {
            error(request, response, "Password is required.", data);
            return;
        }
        boolean hasUpper   = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLower   = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit   = password.chars().anyMatch(Character::isDigit);
        boolean hasSpecial = password.chars().anyMatch(ch -> !Character.isLetterOrDigit(ch));

        if (password.length() < 6 || !hasUpper || !hasLower || !hasDigit || !hasSpecial) {
            error(request, response, "Password must be at least 6 characters and include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.", data);
            return;
        }
        if (!password.equals(confirm)) {
            error(request, response, "Passwords do not match.", data);
            return;
        }

        // Email validation
        if (email.isEmpty()) {
            error(request, response, "Email is required.", data);
            return;
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            error(request, response, "Please enter a valid email address.", data);
            return;
        }

        // Phone validation
        if (phone.isEmpty()) {
            error(request, response, "Phone number is required.", data);
            return;
        }
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            error(request, response, "Please enter a valid phone number (e.g. 0901234567 or +84901234567).", data);
            return;
        }

        // Student Code validation
        if (studentCode.isEmpty()) {
            error(request, response, "Student Code is required.", data);
            return;
        }

        // Academic validation
        if (university.isEmpty()) {
            error(request, response, "University is required.", data);
            return;
        }
        if (major.isEmpty()) {
            error(request, response, "Major is required.", data);
            return;
        }

        // Uniqueness checks
        if (userDAO.existsByUsername(username)) {
            error(request, response, "Username is already taken.", data);
            return;
        }
        if (userDAO.existsByEmail(email)) {
            error(request, response, "Email is already registered.", data);
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
            error(request, response, err, data);
            return;
        }

        // Retrieve the new user to get generated ID
        User created = userDAO.findByUsername(username);
        if (created == null) {
            error(request, response, "Registration failed. Please try again.", data);
            return;
        }

        // --- Build Intern profile ---
        Intern intern = new Intern();
        intern.setUserId(created.getId());
        intern.setStudentCode(studentCode);
        intern.setUniversity(university);
        intern.setMajor(major);
        intern.setGender(gender.isEmpty() ? null : gender);
        intern.setAddress("");
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

    private static class FormData {
        final String username, fullName, email, phone, studentCode, university, major, dateOfBirth, gender;
        FormData(String username, String fullName, String email, String phone, String studentCode,
                 String university, String major, String dateOfBirth, String gender) {
            this.username = username;
            this.fullName = fullName;
            this.email = email;
            this.phone = phone;
            this.studentCode = studentCode;
            this.university = university;
            this.major = major;
            this.dateOfBirth = dateOfBirth;
            this.gender = gender;
        }
    }

    private void error(HttpServletRequest req, HttpServletResponse res, String msg, FormData data)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.setAttribute("username", data.username);
        req.setAttribute("fullName", data.fullName);
        req.setAttribute("email", data.email);
        req.setAttribute("phone", data.phone);
        req.setAttribute("studentCode", data.studentCode);
        req.setAttribute("university", data.university);
        req.setAttribute("major", data.major);
        req.setAttribute("dateOfBirth", data.dateOfBirth);
        req.setAttribute("gender", data.gender);
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, res);
    }

    private String trim(String val) { return val == null ? "" : val.trim(); }
}
