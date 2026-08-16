package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Mentor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * HR Mentor Management.
 *
 * GET  /hr/mentors                 — list mentors with intern count + assignment controls
 * POST /hr/mentors/update          — update mentor department/position/max_interns
 * POST /hr/mentors/assign          — assign intern to mentor
 * POST /hr/mentors/unassign        — remove mentor → intern assignment
 */
@WebServlet(urlPatterns = {"/hr/mentors", "/hr/mentors/update",
                            "/hr/mentors/assign", "/hr/mentors/unassign"})
public class HrMentorServlet extends HttpServlet {

    private MentorDAO mentorDAO;
    private InternDAO internDAO;

    @Override
    public void init() {
        mentorDAO = new MentorDAO();
        internDAO = new InternDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword    = nullToEmpty(request.getParameter("keyword"));
        String department = nullToEmpty(request.getParameter("department"));

        List<Mentor> mentors = mentorDAO.findAll(
                keyword.isEmpty()    ? null : keyword,
                department.isEmpty() ? null : department);

        // All interns available in system for dropdown
        List<Intern> allInterns = internDAO.search(null, null, null, null);

        // Map mentorId -> List of assigned interns
        Map<Long, List<Intern>> mentorAssignments = new HashMap<>();
        int totalAssigned = 0;
        for (Mentor m : mentors) {
            List<Intern> assigned = internDAO.findByMentorRecordId(m.getId());
            mentorAssignments.put(m.getId(), assigned);
            totalAssigned += assigned.size();
        }

        request.setAttribute("mentors",           mentors);
        request.setAttribute("mentorAssignments", mentorAssignments);
        request.setAttribute("allInterns",        allInterns);
        request.setAttribute("totalMentors",      mentors.size());
        request.setAttribute("totalAssigned",     totalAssigned);
        request.setAttribute("keyword",           keyword);
        request.setAttribute("department",        department);
        request.getRequestDispatcher("/WEB-INF/views/hr/mentors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        switch (request.getServletPath()) {
            case "/hr/mentors/update"   -> handleUpdate(request, response);
            case "/hr/mentors/assign"   -> handleAssign(request, response);
            case "/hr/mentors/unassign" -> handleUnassign(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/hr/mentors");
        }
    }

    /** Update mentor's profile details */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId  = parseLong(request.getParameter("mentorId"));
        String dept    = nullToEmpty(request.getParameter("department"));
        String pos     = nullToEmpty(request.getParameter("position"));
        int maxInterns;
        try { maxInterns = Integer.parseInt(request.getParameter("maxInterns")); }
        catch (Exception e) { maxInterns = 5; }

        if (mentorId != null) {
            mentorDAO.update(mentorId, dept, pos, maxInterns);
        }
        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Mentor+profile+updated");
    }

    /** Assign intern to mentor */
    private void handleAssign(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId = parseLong(request.getParameter("mentorId"));
        Long internId = parseLong(request.getParameter("internId"));
        if (mentorId != null && internId != null) {
            mentorDAO.assign(mentorId, internId);
        }
        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Intern+assigned");
    }

    /** Remove intern from mentor */
    private void handleUnassign(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long mentorId = parseLong(request.getParameter("mentorId"));
        Long internId = parseLong(request.getParameter("internId"));
        if (mentorId != null && internId != null) {
            mentorDAO.unassign(mentorId, internId);
        }
        response.sendRedirect(request.getContextPath() + "/hr/mentors?success=Intern+unassigned");
    }

    private Long parseLong(String v) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private String nullToEmpty(String v) { return v == null ? "" : v.trim(); }
}
