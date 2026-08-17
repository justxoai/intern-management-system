package codegym.vn.internmanagement.model;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.PasswordUtil;

import java.util.List;

public class InternModel {

    private final InternDAO internDAO = new InternDAO();

    /**
     * Create an intern profile with an explicit username + password (HR-created account).
     * Creates a proper ACTIVE users record, then inserts the interns row linked to it.
     */
    public String createIntern(Intern intern, String username, String password) {
        // ── Validate personal info ──
        if (isBlank(intern.getFullName())) return "Full name is required.";
        if (isBlank(intern.getEmail()))    return "Email is required.";
        if (isBlank(intern.getPhone()))    return "Phone is required.";
        if (isBlank(intern.getGender()))   return "Gender is required.";

        // ── Validate academic info ──
        if (isBlank(intern.getUniversity())) return "University is required.";
        if (isBlank(intern.getMajor()))      return "Major is required.";

        // ── Validate login credentials ──
        if (isBlank(username)) return "Username is required.";
        if (isBlank(password)) return "Password is required.";
        if (password.length() < 6) return "Password must be at least 6 characters.";

        UserDAO userDAO = new UserDAO();

        // Check uniqueness
        if (userDAO.existsByUsername(username)) return "Username is already taken.";
        if (userDAO.existsByEmail(intern.getEmail())) return "Email is already registered.";

        // Create the ACTIVE user account
        User user = new User(
                username,
                PasswordUtil.hashPassword(password),
                intern.getFullName(),
                intern.getEmail(),
                intern.getPhone(),
                "INTERN",
                "ACTIVE"
        );
        boolean userCreated = userDAO.insert(user);
        if (!userCreated) return "Failed to create user account.";

        // Link the new user_id to the intern record
        User created = userDAO.findByUsername(username);
        if (created != null) {
            intern.setUserId(created.getId());
        }

        boolean inserted = internDAO.insert(intern);
        return inserted ? null : "Failed to create intern profile.";
    }

    /**
     * Legacy overload kept for compatibility (used when no credentials are provided).
     */
    public String createIntern(Intern intern) {
        if (isBlank(intern.getStudentCode())) return "Student code is required.";
        if (isBlank(intern.getUniversity()))  return "University is required.";
        if (isBlank(intern.getMajor()))       return "Major is required.";
        if (isBlank(intern.getEmail()))       return "Email is required.";

        boolean inserted = internDAO.insert(intern);
        return inserted ? null : "Failed to create intern profile.";
    }

    public Intern getInternById(Long id) {
        if (!isValidId(id)) return null;
        return internDAO.findById(id);
    }

    /**
     * Update an intern profile with personal info, academic details, and login credentials.
     */
    public String updateIntern(Intern intern, String username, String password) {
        if (!isValidId(intern.getId())) return "Intern ID is missing or invalid.";

        // ── Validate personal info ──
        if (isBlank(intern.getFullName())) return "Full name is required.";
        if (isBlank(intern.getEmail()))    return "Email is required.";
        if (isBlank(intern.getPhone()))    return "Phone is required.";
        if (isBlank(intern.getGender()))   return "Gender is required.";

        // ── Validate academic info ──
        if (isBlank(intern.getUniversity())) return "University is required.";
        if (isBlank(intern.getMajor()))      return "Major is required.";

        // ── Validate login credentials ──
        if (isBlank(username)) return "Username is required.";
        if (!isBlank(password) && password.length() < 6) {
            return "Password must be at least 6 characters.";
        }

        UserDAO userDAO = new UserDAO();

        // Manage User account
        if (intern.getUserId() != null && intern.getUserId() > 0) {
            User existingUser = userDAO.findById(intern.getUserId());
            if (existingUser != null) {
                // Check if username was changed and if it conflicts with another user
                User userWithNewUsername = userDAO.findByUsername(username);
                if (userWithNewUsername != null && !userWithNewUsername.getId().equals(intern.getUserId())) {
                    return "Username is already taken.";
                }

                existingUser.setFullName(intern.getFullName());
                existingUser.setEmail(intern.getEmail());
                existingUser.setPhone(intern.getPhone());
                userDAO.update(existingUser);
                userDAO.updateUsername(intern.getUserId(), username);

                if (!isBlank(password)) {
                    userDAO.updatePassword(intern.getUserId(), PasswordUtil.hashPassword(password));
                }
            }
        } else {
            // Intern does not have a user account yet -> create one
            if (userDAO.existsByUsername(username)) return "Username is already taken.";
            if (userDAO.existsByEmail(intern.getEmail())) return "Email is already registered.";

            String pass = !isBlank(password) ? password : "123456";
            User newUser = new User(
                    username,
                    PasswordUtil.hashPassword(pass),
                    intern.getFullName(),
                    intern.getEmail(),
                    intern.getPhone(),
                    "INTERN",
                    "ACTIVE"
            );
            if (userDAO.insert(newUser)) {
                User created = userDAO.findByUsername(username);
                if (created != null) {
                    intern.setUserId(created.getId());
                }
            }
        }

        boolean updated = internDAO.update(intern);
        return updated ? null : "Failed to update intern profile.";
    }

    public String updateIntern(Intern intern) {
        if (!isValidId(intern.getId())) return "Intern ID is missing or invalid.";
        boolean updated = internDAO.update(intern);
        return updated ? null : "Failed to update intern profile.";
    }

    public List<Intern> searchInterns(String keyword, String university, String major, String status) {
        return internDAO.search(keyword, university, major, status);
    }

    public String deleteIntern(Long id) {
        if (!isValidId(id)) return "Intern ID is missing or invalid.";
        boolean deleted = internDAO.delete(id);
        return deleted ? null : "Failed to delete intern profile.";
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidId(Long id) {
        return id != null && id > 0;
    }
}
