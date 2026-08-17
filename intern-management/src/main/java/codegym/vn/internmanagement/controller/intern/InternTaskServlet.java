package codegym.vn.internmanagement.controller.intern;

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

/**
 * Intern — My Tasks & Progress Update.
 *
 * GET  /intern/tasks          — view all tasks assigned to me
 * POST /intern/tasks/update   — update status + progress percent
 */
@WebServlet(urlPatterns = {"/intern/tasks", "/intern/tasks/update"})
public class InternTaskServlet extends HttpServlet {

    private InternDAO internDAO;
    private TaskDAO   taskDAO;

    @Override
    public void init() {
        internDAO = new InternDAO();
        taskDAO   = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = currentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Resolve the interns.id for this user
        Intern intern = internDAO.findByUserId(user.getId());

        List<Task> tasks = new ArrayList<>();
        if (intern != null) {
            tasks = taskDAO.findByInternId(intern.getId());
        }

        // Optional status filter
        String statusFilter = nullToEmpty(request.getParameter("status"));
        if (!statusFilter.isEmpty()) {
            tasks = tasks.stream()
                    .filter(t -> statusFilter.equalsIgnoreCase(t.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("tasks",        tasks);
        request.setAttribute("intern",       intern);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("/WEB-INF/views/intern/tasks.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if ("/intern/tasks/update".equals(request.getServletPath())) {
            Long taskId = parseLong(request.getParameter("taskId"));
            String status = nullToEmpty(request.getParameter("status"));
            int progress;
            try { progress = Integer.parseInt(request.getParameter("progress")); }
            catch (Exception e) { progress = 0; }

            if (taskId != null && !status.isEmpty()) {
                taskDAO.updateProgress(taskId, status, progress);
            }
        }
        response.sendRedirect(request.getContextPath() + "/intern/tasks?success=Progress+updated");
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        return s != null ? (User) s.getAttribute("currentUser") : null;
    }

    private Long parseLong(String v) {
        try { return v != null && !v.isBlank() ? Long.parseLong(v) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private String nullToEmpty(String v) { return v == null ? "" : v.trim(); }
}
