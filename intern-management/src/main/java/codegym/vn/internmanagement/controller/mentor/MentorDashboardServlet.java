package codegym.vn.internmanagement.controller.mentor;

import codegym.vn.internmanagement.dao.MentorDAO;
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
import java.time.LocalDate;
import java.util.List;

/**
 * Mentor portal dashboard & task management for assigned interns.
 */
@WebServlet(urlPatterns = {
        "/mentor/dashboard",
        "/mentor/dashboard/task/create",
        "/mentor/dashboard/task/edit",
        "/mentor/dashboard/task/delete"
})
public class MentorDashboardServlet extends HttpServlet {

    private MentorDAO mentorDAO;
    private TaskDAO taskDAO;

    @Override
    public void init() {
        mentorDAO = new MentorDAO();
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long mentorUserId = currentUser.getId();
        String internKeyword = request.getParameter("internKeyword");
        String taskStatus = request.getParameter("taskStatus");
        String internIdFilter = request.getParameter("internId");

        // Fetch assigned interns for this mentor
        List<Intern> allMyInterns = mentorDAO.findInternsByMentorUserId(mentorUserId);
        List<Intern> myInterns = allMyInterns;
        if (internKeyword != null && !internKeyword.isBlank()) {
            String kw = internKeyword.trim().toLowerCase();
            myInterns = allMyInterns.stream().filter(i ->
                    (i.getStudentCode() != null && i.getStudentCode().toLowerCase().contains(kw)) ||
                    (i.getFullName() != null && i.getFullName().toLowerCase().contains(kw)) ||
                    (i.getEmail() != null && i.getEmail().toLowerCase().contains(kw)) ||
                    (i.getUniversity() != null && i.getUniversity().toLowerCase().contains(kw)) ||
                    (i.getMajor() != null && i.getMajor().toLowerCase().contains(kw))
            ).toList();
        }

        // Fetch tasks for this mentor
        List<Task> allTasks = taskDAO.findByMentorUserId(mentorUserId);
        List<Task> tasks = allTasks;
        if (taskStatus != null && !taskStatus.isBlank()) {
            tasks = tasks.stream().filter(t -> taskStatus.equalsIgnoreCase(t.getStatus())).toList();
        }
        if (internIdFilter != null && !internIdFilter.isBlank()) {
            try {
                long iId = Long.parseLong(internIdFilter);
                tasks = tasks.stream().filter(t -> t.getInternId() != null && t.getInternId() == iId).toList();
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("myInterns", myInterns);
        request.setAttribute("allMyInterns", allMyInterns);
        request.setAttribute("tasks", tasks);
        request.setAttribute("internKeyword", internKeyword != null ? internKeyword : "");
        request.setAttribute("taskStatus", taskStatus != null ? taskStatus : "");
        request.setAttribute("internIdFilter", internIdFilter != null ? internIdFilter : "");

        request.getRequestDispatcher("/WEB-INF/views/mentor/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/mentor/dashboard/task/create".equals(path)) {
            handleCreateTask(request, response);
        } else if ("/mentor/dashboard/task/delete".equals(path)) {
            handleDeleteTask(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
        }
    }

    private void handleCreateTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long mentorId = taskDAO.findMentorIdByUserId(currentUser.getId());
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String internIdStr = request.getParameter("internId");
        String status = request.getParameter("status");
        String dueDateStr = request.getParameter("dueDate");

        if (title != null && !title.isBlank() && internIdStr != null && !internIdStr.isBlank()) {
            Task task = new Task();
            task.setTitle(title.trim());
            task.setDescription(desc != null ? desc.trim() : "");
            task.setInternId(Long.parseLong(internIdStr));
            task.setMentorId(mentorId);
            task.setStatus(status != null && !status.isBlank() ? status : "TODO");
            if (dueDateStr != null && !dueDateStr.isBlank()) {
                try {
                    task.setDueDate(LocalDate.parse(dueDateStr));
                } catch (Exception ignored) {}
            }
            taskDAO.insert(task);
        }

        response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
    }

    private void handleDeleteTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isBlank()) {
            try {
                taskDAO.delete(Long.parseLong(idStr));
            } catch (Exception ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
    }
}
