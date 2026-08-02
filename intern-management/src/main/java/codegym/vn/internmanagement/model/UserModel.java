package codegym.vn.internmanagement.model;

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
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));

        boolean inserted = userDAO.insert(user);
        return inserted ? null : "Failed to create user account.";
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
