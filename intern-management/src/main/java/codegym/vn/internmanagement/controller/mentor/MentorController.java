package codegym.vn.internmanagement.controller.mentor;

import java.io.IOException;
import java.util.List;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;
import codegym.vn.internmanagement.entity.MentorAssignment;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.MentorModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/hr/mentors", "/hr/mentors/create", "/hr/mentors/assign", "/hr/mentors/stats"})
public class MentorController extends HttpServlet {

    private MentorModel mentorModel;

    @Override
    public void init() {
        mentorModel = new MentorModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/hr/mentors/create".equals(path)) {
            showCreateForm(request, response);
        } else if ("/hr/mentors/assign".equals(path)) {
            showAssignForm(request, response);
        } else if ("/hr/mentors/stats".equals(path)) {
            showStats(request, response);
        } else {
            showMentors(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/hr/mentors/create".equals(path)) {
            createMentor(request, response);
        } else if ("/hr/mentors/assign".equals(path)) {
            assignMentor(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void showMentors(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Mentor> mentors = mentorModel.getAllMentors();
        request.setAttribute("mentors", mentors);
        request.getRequestDispatcher("/WEB-INF/views/mentor/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = mentorModel.getAvailableMentorUsers();
        request.setAttribute("mentorUsers", users);
        request.getRequestDispatcher("/WEB-INF/views/mentor/create.jsp").forward(request, response);
    }

    private void showAssignForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Mentor> mentors = mentorModel.getAllMentors();
        List<Intern> interns = mentorModel.getAvailableInterns();
        request.setAttribute("mentors", mentors);
        request.setAttribute("interns", interns);
        request.getRequestDispatcher("/WEB-INF/views/mentor/assign.jsp").forward(request, response);
    }

    private void showStats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MentorAssignment> stats = mentorModel.getMentorWorkloadStats();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/mentor/stats.jsp").forward(request, response);
    }

    private void createMentor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Mentor mentor = new Mentor();
        mentor.setUserId(Long.parseLong(request.getParameter("userId")));
        mentor.setDepartment(request.getParameter("department"));
        mentor.setPosition(request.getParameter("position"));
        mentor.setMaxInterns(Integer.parseInt(request.getParameter("maxInterns")));

        String error = mentorModel.createMentor(mentor);
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("mentor", mentor);
            showCreateForm(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/hr/mentors");
    }

    private void assignMentor(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String mentorIdStr = request.getParameter("mentorId");
        String internIdStr = request.getParameter("internId");

        if (mentorIdStr == null || mentorIdStr.isBlank() || internIdStr == null || internIdStr.isBlank()) {
            request.setAttribute("error", "Both mentor and intern must be selected.");
            showAssignForm(request, response);
            return;
        }

        Long mentorId;
        Long internId;
        try {
            mentorId = Long.parseLong(mentorIdStr.trim());
            internId = Long.parseLong(internIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid mentor or intern id.");
            showAssignForm(request, response);
            return;
        }

        String error = mentorModel.assignMentor(mentorId, internId);
        if (error != null) {
            request.setAttribute("error", error);
            showAssignForm(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/hr/mentors/assign");
    }
}
