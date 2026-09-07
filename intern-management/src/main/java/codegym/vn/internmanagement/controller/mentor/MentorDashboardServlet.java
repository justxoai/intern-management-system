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

        String path = request.getServletPath();
        if ("/mentor/dashboard/task/edit".equals(path)) {
            handleEditTaskPage(request, response);
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

    private void handleEditTaskPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long mentorUserId = currentUser.getId();
        List<Intern> allMyInterns = mentorDAO.findInternsByMentorUserId(mentorUserId);
        List<Task> allTasks = taskDAO.findByMentorUserId(mentorUserId);

        String idStr = request.getParameter("id");
        String taskStatus = request.getParameter("taskStatus");
        String keyword = request.getParameter("keyword");

        Long selectedTaskId = null;
        try {
            if (idStr != null && !idStr.isBlank()) selectedTaskId = Long.parseLong(idStr.trim());
        } catch (Exception ignored) {}

        Task selectedTask = null;
        if (selectedTaskId != null) {
            selectedTask = taskDAO.findById(selectedTaskId);
        }

        List<Task> tasks = allTasks;
        if (taskStatus != null && !taskStatus.isBlank()) {
            tasks = tasks.stream().filter(t -> taskStatus.equalsIgnoreCase(t.getStatus())).toList();
        }
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            tasks = tasks.stream().filter(t ->
                    (t.getTitle() != null && t.getTitle().toLowerCase().contains(kw)) ||
                    (t.getDescription() != null && t.getDescription().toLowerCase().contains(kw)) ||
                    (t.getInternName() != null && t.getInternName().toLowerCase().contains(kw))
            ).toList();
        }

        long todoCount = allTasks.stream().filter(t -> "TODO".equalsIgnoreCase(t.getStatus())).count();
        long inProgCount = allTasks.stream().filter(t -> "IN_PROGRESS".equalsIgnoreCase(t.getStatus())).count();
        long doneCount = allTasks.stream().filter(t -> "COMPLETED".equalsIgnoreCase(t.getStatus())).count();

        request.setAttribute("tasks", tasks);
        request.setAttribute("allTasks", allTasks);
        request.setAttribute("allMyInterns", allMyInterns);
        request.setAttribute("selectedTask", selectedTask);
        request.setAttribute("selectedTaskId", selectedTaskId);
        request.setAttribute("taskStatus", taskStatus != null ? taskStatus : "");
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("todoCount", todoCount);
        request.setAttribute("inProgCount", inProgCount);
        request.setAttribute("doneCount", doneCount);

        request.getRequestDispatcher("/WEB-INF/views/mentor/task_edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/mentor/dashboard/task/create".equals(path)) {
            handleCreateTask(request, response);
        } else if ("/mentor/dashboard/task/edit".equals(path)) {
            handleUpdateTask(request, response);
        } else if ("/mentor/dashboard/task/delete".equals(path)) {
            handleDeleteTask(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
        }
    }

    private void handleUpdateTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String internIdStr = request.getParameter("internId");
        String status = request.getParameter("status");
        String progressStr = request.getParameter("progress");
        String dueDateStr = request.getParameter("dueDate");

        Long taskId = null;
        try { if (idStr != null && !idStr.isBlank()) taskId = Long.parseLong(idStr.trim()); } catch (Exception ignored) {}

        if (taskId != null) {
            Task task = taskDAO.findById(taskId);
            if (task != null) {
                if (title != null && !title.isBlank()) {
                    task.setTitle(title.trim());
                }
                if (desc != null) {
                    task.setDescription(desc.trim());
                }
                if (internIdStr != null && !internIdStr.isBlank()) {
                    try { task.setInternId(Long.parseLong(internIdStr.trim())); } catch (Exception ignored) {}
                }

                String newStatus = (status != null && !status.isBlank()) ? status.trim() : task.getStatus();
                task.setStatus(newStatus);

                int progress = task.getProgress();
                try {
                    if (progressStr != null && !progressStr.isBlank()) {
                        progress = Integer.parseInt(progressStr.trim());
                    }
                } catch (Exception ignored) {}

                if ("COMPLETED".equals(newStatus) && progress < 100) {
                    progress = 100;
                } else if ("TODO".equals(newStatus) && progress == 100) {
                    progress = 0;
                }
                task.setProgress(Math.min(100, Math.max(0, progress)));

                if (dueDateStr != null) {
                    if (!dueDateStr.isBlank()) {
                        try {
                            task.setDueDate(LocalDate.parse(dueDateStr.trim()));
                        } catch (Exception ignored) {
                            task.setDueDate(null);
                        }
                    } else {
                        task.setDueDate(null);
                    }
                }

                taskDAO.update(task);
            }
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/mentor/dashboard/task/edit")) {
            response.sendRedirect(request.getContextPath() + "/mentor/dashboard/task/edit?success=C%E1%BA%ADp+nh%E1%BA%ADt+nhi%E1%BB%87m+v%E1%BB%A5+th%C3%A0nh+c%C3%B4ng");
        } else {
            response.sendRedirect(request.getContextPath() + "/mentor/dashboard?success=C%E1%BA%ADp+nh%E1%BA%ADt+nhi%E1%BB%87m+v%E1%BB%A5+th%C3%A0nh+c%C3%B4ng");
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
