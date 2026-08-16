package codegym.vn.internmanagement.model;

import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.PasswordUtil;

import java.util.List;

/**
 * Model/Service layer handling business logic and validation for User operations.
 */
public class UserModel {

    private final UserDAO userDAO;

    public UserModel() {
        this.userDAO = new UserDAO();
    }

    public UserModel(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Retrieve all users.
     *
     * @return List of Users
     */
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    /**
     * Search users for Admin Dashboard including intern information.
     *
     * @param keyword search keyword
     * @return List of Users matching criteria
     */
    public List<User> searchAdminUsers(String keyword) {
        return userDAO.searchAdminUsers(keyword);
    }

    /**
     * Find user by ID.
     *
     * @param id User ID
     * @return User object or null
     */
    public User getUserById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        return userDAO.findById(id);
    }

    /**
     * Create a new user account with validation.
     * Validation rules:
     * - Username, Password, FullName, Email are required.
     * - Username must be unique.
     * - Email must be unique.
     * - Role must be valid (HR, MENTOR, INTERN). ADMIN creation restricted.
     *
     * @param user User entity to insert
     * @return Error message if validation fails, or null if creation succeeds.
     */
    public String createUser(User user) {
        // Validate required fields
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            return "Username is required.";
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return "Password is required.";
        }
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            return "Full Name is required.";
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return "Email is required.";
        }
        if (!user.getEmail().trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Please enter a valid email address.";
        }

        if (user.getPhone() == null || user.getPhone().trim().isEmpty()) {
            return "Phone number is required.";
        }
        if (!user.getPhone().trim().matches("^(?:\\+84|0)[0-9]{9,10}$")) {
            return "Please enter a valid phone number (e.g. 0901234567).";
        }

        // Validate password complexity: 1 Upper, 1 Lower, 1 Digit, 1 Special character, min 6 chars
        String rawPassword = user.getPassword();
        boolean hasUpper   = rawPassword.chars().anyMatch(Character::isUpperCase);
        boolean hasLower   = rawPassword.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit   = rawPassword.chars().anyMatch(Character::isDigit);
        boolean hasSpecial = rawPassword.chars().anyMatch(ch -> !Character.isLetterOrDigit(ch));

        if (rawPassword.length() < 6 || !hasUpper || !hasLower || !hasDigit || !hasSpecial) {
            return "Password must be at least 6 characters and contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.";
        }

        // Validate uniqueness
        if (userDAO.existsByUsername(user.getUsername())) {
            return "Username is already taken.";
        }
        if (userDAO.existsByEmail(user.getEmail())) {
            return "Email is already registered.";
        }

        // Validate role
        String role = user.getRole();
        if (role == null || (!role.equals("HR") && !role.equals("MENTOR") && !role.equals("INTERN"))) {
            return "Invalid role specified.";
        }

        // Hash password before saving to the database
        user.setPassword(PasswordUtil.hashPassword(rawPassword));

        boolean inserted = userDAO.insert(user);
        if (!inserted) return "Failed to create user account.";

        // #8 — Auto-create a mentors profile when role is MENTOR
        if ("MENTOR".equalsIgnoreCase(role)) {
            User created = userDAO.findByUsername(user.getUsername());
            if (created != null) {
                MentorDAO mentorDAO = new MentorDAO();
                mentorDAO.insert(created.getId(), "", "", 5);
            }
        }
        return null;
    }

    /**
     * Update an existing user account.
     *
     * @param user User entity with updated values
     * @return Error message if validation fails, or null if update succeeds.
     */
    public String updateUser(User user) {
        if (user.getId() == null) return "Invalid user ID.";
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) return "Full Name is required.";
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) return "Email is required.";

        return userDAO.update(user) ? null : "Failed to update user.";
    }

    /**
     * Delete a user by ID.
     *
     * @param id User ID
     * @return true if deletion succeeded
     */
    public boolean deleteUser(Long id) {
        if (id == null || id <= 0) return false;
        return userDAO.delete(id);
    }

    /**
     * Validate user login credentials.
     *
     * @param username Username
     * @param password Password
     * @return User object if valid, null otherwise
     */
    public User authenticate(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        User user = userDAO.findByUsername(username);
        if (user != null) {
            // Verify using hash, or fallback to plain-text check for DB-seeded users
            if (PasswordUtil.checkPassword(password, user.getPassword()) || password.equals(user.getPassword())) {
                return user;
            }
        }
        return null;
    }
}
