package codegym.vn.internmanagement.model;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Intern;

import java.util.List;

/**
 * Model/Service layer handling business logic and validation for Intern profile operations.
 */
public class InternModel {

    private final InternDAO internDAO;

    public InternModel() {
        this.internDAO = new InternDAO();
    }

    public InternModel(InternDAO internDAO) {
        this.internDAO = internDAO;
    }

    /**
     * Create a new Intern profile with input validation.
     * Validation rules:
     * - Student code, University, Major, Email are required.
     *
     * @param intern Intern entity
     * @return Error message if validation fails, or null if creation succeeds.
     */
    public String createIntern(Intern intern) {
        if (intern.getStudentCode() == null || intern.getStudentCode().trim().isEmpty()) {
            return "Student code is required.";
        }
        if (intern.getUniversity() == null || intern.getUniversity().trim().isEmpty()) {
            return "University is required.";
        }
        if (intern.getMajor() == null || intern.getMajor().trim().isEmpty()) {
            return "Major is required.";
        }
        if (intern.getEmail() == null || intern.getEmail().trim().isEmpty()) {
            return "Email is required.";
        }

        boolean inserted = internDAO.insert(intern);
        return inserted ? null : "Failed to create intern profile.";
    }

    /**
     * Retrieve Intern profile by ID.
     *
     * @param id Intern ID
     * @return Intern object or null
     */
    public Intern getInternById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        return internDAO.findById(id);
    }

    /**
     * Update an existing intern profile.
     *
     * @param intern Intern entity
     * @return Error message if validation fails, or null if update succeeds.
     */
    public String updateIntern(Intern intern) {
        if (intern.getId() == null) {
            return "Intern ID is missing.";
        }
        if (intern.getStudentCode() == null || intern.getStudentCode().trim().isEmpty()) {
            return "Student code is required.";
        }

        boolean updated = internDAO.update(intern);
        return updated ? null : "Failed to update intern profile.";
    }

    /**
     * Search and filter interns by keyword, university, major, and status.
     *
     * @param keyword    Keyword string
     * @param university University filter
     * @param major      Major filter
     * @param status     Status filter
     * @return List of matching Interns
     */
    public List<Intern> searchInterns(String keyword, String university, String major, String status) {
        return internDAO.search(keyword, university, major, status);
    }
}
