package codegym.vn.internmanagement.controller.mentor;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.TaskDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.Task;
import codegym.vn.internmanagement.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Mentor Dashboard: My Interns + Task Assignment.
 * tasks.mentor_id references mentors.id (NOT users.id).
 * So we first resolve the mentor's mentors.id record.
 *
 * GET  /mentor/dashboard
 * POST /mentor/dashboard/task/create
 * POST /mentor/dashboard/task/edit
 * POST /mentor/dashboard/task/delete
 * GET  /mentor/dashboard/task/edit?id=X
 */
@WebServlet(urlPatterns = {"/mentor/dashboard", "/mentor/dashboard/task/create",
                           "/mentor/dashboard/task/edit", "/mentor/dashboard/task/delete"})
public class MentorDashboardServlet extends HttpServlet {

    private InternDAO internDAO;
    private TaskDAO taskDAO;

    @Override
    public void init() {
        internDAO = new InternDAO();
        taskDAO   = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/mentor/dashboard/task/edit".equals(request.getServletPath())) {
            showTaskEditForm(request, response);
        } else {
            showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/mentor/dashboard/task/create" -> createTask(request, response);
            case "/mentor/dashboard/task/edit"   -> updateTask(request, response);
            case "/mentor/dashboard/task/delete" -> deleteTask(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
        }
    }

    // ------------------------------------------------------------------ //

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long userSessionId = getCurrentUserId(request);

        // My Interns via mentor_assignments
        List<Intern> myInterns = userSessionId != null
                ? internDAO.findByMentorId(userSessionId)
                : new ArrayList<>();

        // Keyword filter on interns
        String internKeyword = nullToEmpty(request.getParameter("internKeyword"));
        if (!internKeyword.isEmpty()) {
            myInterns = myInterns.stream()
                    .filter(i -> containsIgnoreCase(i.getStudentCode(), internKeyword)
                              || containsIgnoreCase(i.getFullName(), internKeyword)
                              || containsIgnoreCase(i.getEmail(), internKeyword))
                    .collect(Collectors.toList());
        }

        // Tasks — resolved via mentors table
        List<Task> tasks = userSessionId != null
                ? taskDAO.findByMentorUserId(userSessionId)
                : new ArrayList<>();

        String taskStatus = nullToEmpty(request.getParameter("taskStatus"));
        if (!taskStatus.isEmpty()) {
            tasks = tasks.stream()
                    .filter(t -> taskStatus.equalsIgnoreCase(t.getStatus()))
                    .collect(Collectors.toList());
        }

        // Interns available for task dropdown (unfiltered)
        List<Intern> allMyInterns = userSessionId != null
                ? internDAO.findByMentorId(userSessionId)
                : new ArrayList<>();

        request.setAttribute("myInterns",    myInterns);
        request.setAttribute("allMyInterns", allMyInterns);
        request.setAttribute("tasks",        tasks);
        request.setAttribute("internKeyword", internKeyword);
        request.setAttribute("taskStatus",   taskStatus);

        request.getRequestDispatcher("/WEB-INF/views/mentor/dashboard.jsp")
                .forward(request, response);
    }

    private void showTaskEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = parseId(request.getParameter("id"));
        Long userId = getCurrentUserId(request);
        Task task = id != null ? taskDAO.findById(id) : null;
        List<Intern> allMyInterns = userId != null
                ? internDAO.findByMentorId(userId)
                : new ArrayList<>();
        request.setAttribute("task",         task);
        request.setAttribute("allMyInterns", allMyInterns);
        request.getRequestDispatcher("/WEB-INF/views/mentor/task_edit.jsp").forward(request, response);
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long userId = getCurrentUserId(request);
        // Resolve mentors.id from users.id
        Long mentorRecordId = userId != null ? taskDAO.findMentorIdByUserId(userId) : null;

        if (mentorRecordId == null) {
            response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
            return;
        }

        Task task = new Task();
        task.setTitle(request.getParameter("title"));
        task.setDescription(request.getParameter("description"));
        task.setInternId(parseId(request.getParameter("internId")));
        task.setMentorId(mentorRecordId);
        task.setStatus(nullToEmpty(request.getParameter("status")).isEmpty() ? "TODO" : request.getParameter("status"));
        String dueDateStr = request.getParameter("dueDate");
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            task.setDueDate(java.time.LocalDate.parse(dueDateStr));
        }
        taskDAO.insert(task);
        response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = parseId(request.getParameter("id"));
        if (id != null) {
            Task task = new Task();
            task.setId(id);
            task.setTitle(request.getParameter("title"));
            task.setDescription(request.getParameter("description"));
            task.setInternId(parseId(request.getParameter("internId")));
            task.setStatus(request.getParameter("status"));
            String dueDateStr = request.getParameter("dueDate");
            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                task.setDueDate(java.time.LocalDate.parse(dueDateStr));
            }
            taskDAO.update(task);
        }
        response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = parseId(request.getParameter("id"));
        if (id != null) taskDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
    }

    // ------------------------------------------------------------------ //

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("currentUser");
        return user != null ? user.getId() : null;
    }

    private String nullToEmpty(String val) { return val == null ? "" : val.trim(); }

    private boolean containsIgnoreCase(String src, String q) {
        return src != null && src.toLowerCase().contains(q.toLowerCase());
    }

    private Long parseId(String val) {
        try { return val != null && !val.isEmpty() ? Long.parseLong(val) : null; }
        catch (NumberFormatException e) { return null; }
    }
}
