package codegym.vn.internmanagement.model;

import java.util.List;

import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.entity.Mentor;

public class MentorModel {

    private final MentorDAO mentorDAO = new MentorDAO();

    public List<Mentor> getAllMentors() {
        return mentorDAO.findAll(null, null);
    }

    public String createMentor(Mentor mentor) {
        if (mentor.getUserId() == null || mentor.getUserId() <= 0) {
            return "Please select a mentor user.";
        }
        if (mentor.getDepartment() == null || mentor.getDepartment().trim().isEmpty()) {
            return "Department is required.";
        }
        if (mentor.getPosition() == null || mentor.getPosition().trim().isEmpty()) {
            return "Position is required.";
        }
        if (mentor.getMaxInterns() <= 0) {
            return "Maximum interns must be greater than 0.";
        }
        return mentorDAO.insert(mentor.getUserId(), mentor.getDepartment(), mentor.getPosition(), mentor.getMaxInterns())
                ? null : "Failed to create mentor profile.";
    }

    public String assignMentor(Long mentorId, Long internId) {
        if (mentorId == null || mentorId <= 0) {
            return "Please select a mentor.";
        }
        if (internId == null || internId <= 0) {
            return "Please select an intern.";
        }
        return mentorDAO.assign(mentorId, internId) ? null : "Failed to assign mentor.";
    }
}
