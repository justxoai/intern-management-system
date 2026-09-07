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
            return "Tên đăng nhập là bắt buộc.";
        }
        // Trim username trước khi lưu
        user.setUsername(user.getUsername().trim());
        // Chỉ cho phép chữ cái, số, dấu chấm, gạch dưới, gạch ngang (3-30 ký tự)
        if (!user.getUsername().matches("^[a-zA-Z0-9._-]{3,30}$")) {
            return "Tên đăng nhập chỉ được chứa chữ cái, số, dấu chấm, gạch dưới hoặc gạch ngang (3–30 ký tự).";
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return "Mật khẩu là bắt buộc.";
        }
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            return "Họ và tên là bắt buộc.";
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return "Email là bắt buộc.";
        }
        if (!user.getEmail().trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Vui lòng nhập địa chỉ email hợp lệ.";
        }

        if (user.getPhone() == null || user.getPhone().trim().isEmpty()) {
            return "Số điện thoại là bắt buộc.";
        }
        // Chuẩn: đầu số hợp lệ VN (03x,05x,07x,08x,09x), tổng 10 số; hoặc +84 + 9 số
        if (!user.getPhone().trim().matches("^(?:\\+84|0)(3[2-9]|5[6-9]|7[06-9]|8[0-9]|9[0-9])\\d{7}$")) {
            return "Số điện thoại không hợp lệ. Ví dụ: 0901234567 hoặc +84901234567.";
        }

        // Validate password complexity: 1 Upper, 1 Lower, 1 Digit, 1 Special character, min 6 chars
        String rawPassword = user.getPassword();
        boolean hasUpper   = rawPassword.chars().anyMatch(Character::isUpperCase);
        boolean hasLower   = rawPassword.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit   = rawPassword.chars().anyMatch(Character::isDigit);
        boolean hasSpecial = rawPassword.chars().anyMatch(ch -> !Character.isLetterOrDigit(ch));

        if (rawPassword.length() < 6 || !hasUpper || !hasLower || !hasDigit || !hasSpecial) {
            return "Mật khẩu phải có ít nhất 6 ký tự, gồm: 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt.";
        }

        // Validate uniqueness
        if (userDAO.existsByUsername(user.getUsername())) {
            return "Tên đăng nhập đã được sử dụng.";
        }
        if (userDAO.existsByEmail(user.getEmail())) {
            return "Email đã được đăng ký.";
        }

        // Validate role
        String role = user.getRole();
        if (role == null || (!role.equals("HR") && !role.equals("MENTOR") && !role.equals("INTERN"))) {
            return "Vai trò không hợp lệ.";
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

        // Auto-create an interns profile when role is INTERN
        if ("INTERN".equalsIgnoreCase(role)) {
            User created = userDAO.findByUsername(user.getUsername());
            if (created != null) {
                codegym.vn.internmanagement.dao.InternDAO internDAO =
                        new codegym.vn.internmanagement.dao.InternDAO();
                codegym.vn.internmanagement.entity.Intern intern =
                        new codegym.vn.internmanagement.entity.Intern();
                intern.setUserId(created.getId());
                intern.setStudentCode("");
                intern.setUniversity("");
                intern.setMajor("");
                intern.setEmail(created.getEmail());
                intern.setPhone(created.getPhone());
                intern.setStatus("PENDING");
                internDAO.insert(intern);
            }
        }

        return null;
    }

    /**
     * Update an existing user account with optional new password and username.
     *
     * @param user User entity with updated values
     * @param password Optional new password (can be null/empty to keep existing)
     * @return Error message if validation fails, or null if update succeeds.
     */
    public String updateUser(User user, String password) {
        if (user.getId() == null || user.getId() <= 0) return "ID người dùng không hợp lệ.";
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) return "Họ và tên là bắt buộc.";
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) return "Email là bắt buộc.";
        if (!user.getEmail().trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Vui lòng nhập địa chỉ email hợp lệ.";
        }

        // Validate phone (cho phép để trống nếu đã có)
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
            if (!user.getPhone().trim().matches("^(?:\\+84|0)(3[2-9]|5[6-9]|7[06-9]|8[0-9]|9[0-9])\\d{7}$")) {
                return "Số điện thoại không hợp lệ. Ví dụ: 0901234567 hoặc +84901234567.";
            }
        }

        // Validate username
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            return "Tên đăng nhập là bắt buộc.";
        }
        user.setUsername(user.getUsername().trim());
        if (!user.getUsername().matches("^[a-zA-Z0-9._-]{3,30}$")) {
            return "Tên đăng nhập chỉ được chứa chữ cái, số, dấu chấm, gạch dưới hoặc gạch ngang (3–30 ký tự).";
        }
        User existingUserWithUsername = userDAO.findByUsername(user.getUsername());
        if (existingUserWithUsername != null && !existingUserWithUsername.getId().equals(user.getId())) {
            return "Tên đăng nhập đã được sử dụng.";
        }

        // Validate role
        String role = user.getRole();
        if (role == null || (!role.equals("HR") && !role.equals("MENTOR") && !role.equals("INTERN") && !role.equals("ADMIN"))) {
            return "Vai trò không hợp lệ.";
        }

        // Validate password if provided
        if (password != null && !password.trim().isEmpty()) {
            if (password.trim().length() < 6) {
                return "Mật khẩu phải có ít nhất 6 ký tự.";
            }
            user.setPassword(PasswordUtil.hashPassword(password.trim()));
            userDAO.updatePassword(user.getId(), user.getPassword());
        }

        userDAO.updateUsername(user.getId(), user.getUsername());
        return userDAO.update(user) ? null : "Không thể cập nhật thông tin người dùng.";
    }

    public String updateUser(User user) {
        return updateUser(user, null);
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
