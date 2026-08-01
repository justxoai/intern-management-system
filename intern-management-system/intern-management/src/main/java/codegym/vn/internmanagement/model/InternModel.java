package codegym.vn.internmanagement.model;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Intern;
import java.util.List;

public class InternModel {

    private final InternDAO internDAO = new InternDAO();

    public String createIntern(Intern intern) {
        if (isBlank(intern.getStudentCode())) {
            return "Student code is required.";
        }
        if (isBlank(intern.getUniversity())) {
            return "University is required.";
        }
        if (isBlank(intern.getMajor())) {
            return "Major is required.";
        }
        if (isBlank(intern.getEmail())) {
            return "Email is required.";
        }

        boolean inserted = internDAO.insert(intern);
        return inserted ? null : "Failed to create intern profile.";
    }

    public Intern getInternById(Long id) {
        if (!isValidId(id)) {
            return null;
        }
        return internDAO.findById(id);
    }

    public String updateIntern(Intern intern) {
        if (!isValidId(intern.getId())) {
            return "Intern ID is missing or invalid.";
        }
        if (isBlank(intern.getStudentCode())) {
            return "Student code is required.";
        }

        boolean updated = internDAO.update(intern);
        return updated ? null : "Failed to update intern profile.";
    }

    public List<Intern> searchInterns(String keyword, String university, String major, String status) {
        return internDAO.search(keyword, university, major, status);
    }

    public String deleteIntern(Long id) {
        if (!isValidId(id)) {
            return "Intern ID is missing or invalid.";
        }
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
