package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * HR Mentor Management.
 *
 * GET  /hr/mentors                 — list mentors with intern count + assignment controls
 * GET  /hr/mentors/create          — display mentor creation form
 * POST /hr/mentors/create          — create a new mentor account and profile
 * POST /hr/mentors/update          — update mentor department/position/max_interns
 * POST /hr/mentors/assign          — assign intern to mentor
 * POST /hr/mentors/unassign        — remove mentor → intern assignment
 */
@WebServlet(urlPatterns = {"/hr/mentors", "/hr/mentors/create", "/hr/mentors/update",
                            "/hr/mentors/assign", "/hr/mentors/unassign"})
public class HrMentorServlet extends HttpServlet {

    private MentorDAO mentorDAO;
    private InternDAO internDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        mentorDAO = new MentorDAO();
        internDAO = new InternDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/hr/mentors/create".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/hr/mentor_create.jsp").forward(request, response);
            return;
        }

        String keyword    = nullToEmpty(request.getParameter("keyword"));
        String department = nullToEmpty(request.getParameter("department"));

        List<Mentor> mentors = mentorDAO.findAll(
                keyword.isEmpty()    ? null : keyword,
                department.isEmpty() ? null : department);

        // All interns available in system for dropdown
        List<Intern> allInterns = internDAO.search(null, null, null, null);

        // Map mentorId -> List of assigned interns
        Map<Long, List<Intern>> mentorAssignments = new HashMap<>();
        int totalAssigned = 0;
        for (Mentor m : mentors) {
            List<Intern> assigned = internDAO.findByMentorRecordId(m.getId());
            mentorAssignments.put(m.getId(), assigned);
            totalAssigned += assigned.size();
        }

        request.setAttribute("mentors",           mentors);
        request.setAttribute("mentorAssignments", mentorAssignments);
        request.setAttribute("allInterns",        allInterns);
        request.setAttribute("totalMentors",      mentors.size());
        request.setAttribute("totalAssigned",     totalAssigned);
        request.setAttribute("keyword",           keyword);
        request.setAttribute("department",        department);
        request.getRequestDispatcher("/WEB-INF/views/hr/mentors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getServletPath()) {
            case "/hr/mentors/create"   -> handleCreate(request, response);
            case "/hr/mentors/update"   -> handleUpdate(request, response);
            case "/hr/mentors/assign"   -> handleAssign(request, response);
            case "/hr/mentors/unassign" -> handleUnassign(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/hr/mentors");
        }
    }

    /** Create a new mentor account and profile */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName   = nullToEmpty(request.getParameter("fullName"));
        String email      = nullToEmpty(request.getParameter("email"));
        String phone      = nullToEmpty(request.getParameter("phone"));
        String department = nullToEmpty(request.getParameter("department"));
        String position   = nullToEmpty(request.getParameter("position"));
        String username   = nullToEmpty(request.getParameter("username"));
        String password   = nullToEmpty(request.getParameter("password"));

        int maxInterns;
        try {
            maxInterns = Integer.parseInt(request.getParameter("maxInterns"));
            if (maxInterns <= 0) maxInterns = 5;
        } catch (Exception e) {
            maxInterns = 5;
        }

        // Validation
        if (fullName.isEmpty()) {
            forwardWithError(request, response, "Full Name is required.");
            return;
        }
        if (email.isEmpty() || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            forwardWithError(request, response, "A valid Email address is required.");
            return;
        }
        if (phone.isEmpty()) {
            forwardWithError(request, response, "Phone Number is required.");
            return;
        }
        if (username.isEmpty()) {
            forwardWithError(request, response, "Username is required.");
            return;
        }
        if (password.isEmpty() || password.length() < 6) {
            forwardWithError(request, response, "Password must be at least 6 characters.");
            return;
        }

        if (userDAO.existsByUsername(username)) {
            forwardWithError(request, response, "Username is already taken.");
            return;
        }
        if (userDAO.existsByEmail(email)) {
            forwardWithError(request, response, "Email is already registered.");
            return;
        }

        // Create User
        User user = new User(
                username,
                PasswordUtil.hashPassword(password),
                fullName,
                email,
                phone,
                "MENTOR",
                "ACTIVE"
        );

        if (!userDAO.insert(user)) {
            forwardWithError(request, response, "Failed to create user account.");
            return;
        }

        User created = userDAO.findByUsername(username);
        if (created == null) {
            forwardWithError(request, response, "Failed to retrieve created user account.");
            return;
        }

        // Create Mentor Record
        if (!mentorDAO.insert(created.getId(), department, position, maxInterns)) {
            forwardWithError(request, response, "Failed to create mentor profile.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Mentor+profile+created+successfully");
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.getRequestDispatcher("/WEB-INF/views/hr/mentor_create.jsp").forward(request, response);
    }

    /** Update mentor's profile details */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId  = parseLong(request.getParameter("mentorId"));
        String dept    = nullToEmpty(request.getParameter("department"));
        String pos     = nullToEmpty(request.getParameter("position"));
        int maxInterns;
        try { maxInterns = Integer.parseInt(request.getParameter("maxInterns")); }
        catch (Exception e) { maxInterns = 5; }

        if (mentorId != null) {
            mentorDAO.update(mentorId, dept, pos, maxInterns);
        }
        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Mentor+profile+updated");
    }

    /** Assign intern to mentor */
    private void handleAssign(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId = parseLong(request.getParameter("mentorId"));
        Long internId = parseLong(request.getParameter("internId"));
        if (mentorId != null && internId != null) {
            Mentor mentor = mentorDAO.findById(mentorId);
            if (mentor != null && mentor.getCurrentInternCount() >= mentor.getMaxInterns()) {
                String encodedName = java.net.URLEncoder.encode(mentor.getFullName() != null ? mentor.getFullName() : "Mentor", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/hr/mentors?error=" + encodedName + "+has+reached+maximum+intern+capacity+(" + mentor.getMaxInterns() + ")");
                return;
            }
            boolean assigned = mentorDAO.assign(mentorId, internId);
            if (!assigned) {
                response.sendRedirect(request.getContextPath() + "/hr/mentors?error=Could+not+assign+intern.+Mentor+may+be+at+maximum+capacity.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Intern+assigned");
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/mentors");
        }
    }

    /** Remove intern from mentor */
    private void handleUnassign(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId = parseLong(request.getParameter("mentorId"));
        Long internId = parseLong(request.getParameter("internId"));
        if (mentorId != null && internId != null) {
            mentorDAO.unassign(mentorId, internId);
        }
        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Intern+unassigned");
    }

    private Long parseLong(String v) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private String nullToEmpty(String v) { return v == null ? "" : v.trim(); }
}
