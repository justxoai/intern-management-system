package codegym.vn.internmanagement.model;

import java.util.List;

import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.User;

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

        if (userDAO.existsByUsername(user.getUsername())) {
            return "Username is already taken.";
        }
        if (userDAO.existsByEmail(user.getEmail())) {
            return "Email is already registered.";
        }

        String role = user.getRole();
        if (role == null || (!role.equals("HR") && !role.equals("MENTOR") && !role.equals("INTERN"))) {
            return "Invalid role specified.";
        }

        boolean inserted = userDAO.insert(user);
        return inserted ? null : "Failed to create user account.";
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
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
    }
}
