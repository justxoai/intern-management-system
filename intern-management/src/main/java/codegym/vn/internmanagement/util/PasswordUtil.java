package codegym.vn.internmanagement.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for hashing and verifying passwords using SHA-256.
 */
public class PasswordUtil {

    private PasswordUtil() {
        // Prevent instantiation
    }

    /**
     * Hashes a plain text password using SHA-256.
     *
     * @param plainPassword the raw password to hash
     * @return 64-character hexadecimal SHA-256 hash string, or null if input is null
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Checks if a plain text password matches a stored hashed password.
     * Also supports direct equality check for plain-text seed data.
     *
     * @param plainPassword  the raw password entered by user
     * @param hashedPassword the stored password (hash or plain-text)
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        // Direct match check (for initial DB seed plain-text passwords)
        if (plainPassword.equals(hashedPassword)) {
            return true;
        }
        // Hash check
        String computedHash = hashPassword(plainPassword);
        return computedHash != null && computedHash.equalsIgnoreCase(hashedPassword);
    }
}
