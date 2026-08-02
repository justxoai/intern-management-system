package codegym.vn.internmanagement.model;

import java.util.List;

import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;
import codegym.vn.internmanagement.entity.MentorAssignment;
import codegym.vn.internmanagement.entity.User;

public class MentorModel {

    private final MentorDAO mentorDAO = new MentorDAO();

    public List<Mentor> getAllMentors() {
        return mentorDAO.findAll();
    }

    public List<User> getAvailableMentorUsers() {
        return mentorDAO.findAvailableMentorUsers();
    }

    public List<Intern> getAvailableInterns() {
        return mentorDAO.findAvailableInterns();
    }

    public List<MentorAssignment> getAssignments() {
        return mentorDAO.findAssignments();
    }

    public List<MentorAssignment> getMentorWorkloadStats() {
        return mentorDAO.findMentorWorkloadStats();
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
        if (mentor.getMaxInterns() == null || mentor.getMaxInterns() <= 0) {
            return "Maximum interns must be greater than 0.";
        }
        return mentorDAO.insert(mentor) ? null : "Failed to create mentor profile.";
    }

    public String assignMentor(Long mentorId, Long internId) {
        if (mentorId == null || mentorId <= 0) {
            return "Please select a mentor.";
        }
        if (internId == null || internId <= 0) {
            return "Please select an intern.";
        }
        return mentorDAO.assignMentor(mentorId, internId) ? null : "Failed to assign mentor.";
    }
}
