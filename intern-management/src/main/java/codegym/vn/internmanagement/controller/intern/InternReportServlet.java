package codegym.vn.internmanagement.controller.intern;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.WeeklyReportDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.entity.WeeklyReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/intern/reports", "/intern/reports/create", "/intern/reports/edit"})
public class InternReportServlet extends HttpServlet {

    private InternDAO internDAO;
    private WeeklyReportDAO reportDAO;

    @Override
    public void init() {
        internDAO = new InternDAO();
        reportDAO = new WeeklyReportDAO();
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

        Intern intern = internDAO.findByUserId(currentUser.getId());
        List<WeeklyReport> reports = new ArrayList<>();
        Long assignedMentorId = null;
        int nextWeekNumber = 1;

        if (intern != null) {
            reports = reportDAO.findByInternId(intern.getId());
            assignedMentorId = reportDAO.findAssignedMentorIdByInternId(intern.getId());
            if (!reports.isEmpty()) {
                int maxWeek = reports.stream().mapToInt(WeeklyReport::getWeekNumber).max().orElse(0);
                nextWeekNumber = maxWeek + 1;
            }
        }

        long submittedCount = reports.stream().filter(r -> "SUBMITTED".equals(r.getStatus())).count();
        long reviewedCount = reports.stream().filter(r -> "REVIEWED".equals(r.getStatus())).count();

        request.setAttribute("intern", intern);
        request.setAttribute("reports", reports);
        request.setAttribute("assignedMentorId", assignedMentorId);
        request.setAttribute("nextWeekNumber", nextWeekNumber);
        request.setAttribute("submittedCount", submittedCount);
        request.setAttribute("reviewedCount", reviewedCount);

        request.getRequestDispatcher("/WEB-INF/views/intern/reports.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Intern intern = internDAO.findByUserId(currentUser.getId());
        if (intern == null) {
            response.sendRedirect(request.getContextPath() + "/intern/reports?error=Ch%C6%B0a+c%C3%B3+h%E1%BB%93+s%C6%A1+th%E1%BB%B1c+t%E1%BA%ADp+sinh");
            return;
        }

        String path = request.getServletPath();
        if ("/intern/reports/create".equals(path)) {
            handleCreateReport(request, response, intern);
        } else if ("/intern/reports/edit".equals(path)) {
            handleEditReport(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/intern/reports");
        }
    }

    private void handleCreateReport(HttpServletRequest request, HttpServletResponse response, Intern intern)
            throws IOException {
        String weekStr = request.getParameter("weekNumber");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String mentorIdStr = request.getParameter("mentorId");

        int weekNumber = 1;
        try {
            if (weekStr != null && !weekStr.isBlank()) weekNumber = Integer.parseInt(weekStr.trim());
        } catch (Exception ignored) {}

        Long mentorId = null;
        try {
            if (mentorIdStr != null && !mentorIdStr.isBlank()) mentorId = Long.parseLong(mentorIdStr.trim());
        } catch (Exception ignored) {}

        if (mentorId == null) {
            mentorId = reportDAO.findAssignedMentorIdByInternId(intern.getId());
        }

        if (mentorId == null) {
            response.sendRedirect(request.getContextPath() + "/intern/reports?error=B%E1%BA%A1n+ch%C6%B0a+%C4%91%C6%B0%E1%BB%A3c+ph%C3%A2n+c%C3%B4ng+Mentor");
            return;
        }

        if (title == null || title.isBlank() || content == null || content.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/intern/reports?error=Vui+l%C3%B2ng+%C4%91i%E1%BB%81n+%C4%91%E1%BA%A7y+%C4%91%E1%BB%A7+ti%C3%AAu+%C4%91%E1%BB%81+v%C3%A0+n%E1%BB%99i+dung");
            return;
        }

        WeeklyReport wr = new WeeklyReport();
        wr.setInternId(intern.getId());
        wr.setMentorId(mentorId);
        wr.setWeekNumber(weekNumber);
        wr.setTitle(title.trim());
        wr.setContent(content.trim());

        boolean ok = reportDAO.create(wr);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/intern/reports?success=N%E1%BB%99p+b%C3%A1o+c%C3%A1o+tu%E1%BA%A7n+th%C3%A0nh+c%C3%B4ng");
        } else {
            response.sendRedirect(request.getContextPath() + "/intern/reports?error=Kh%C3%B4ng+th%E1%BB%83+l%C6%B0u+b%C3%A1o+c%C3%A1o");
        }
    }

    private void handleEditReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        Long id = null;
        try {
            if (idStr != null && !idStr.isBlank()) id = Long.parseLong(idStr.trim());
        } catch (Exception ignored) {}

        if (id != null && title != null && !title.isBlank() && content != null && !content.isBlank()) {
            reportDAO.updateContent(id, title.trim(), content.trim());
            response.sendRedirect(request.getContextPath() + "/intern/reports?success=C%E1%BA%ADp+nh%E1%BA%ADt+b%C3%A1o+c%C3%A1o+th%C3%A0nh+c%C3%B4ng");
        } else {
            response.sendRedirect(request.getContextPath() + "/intern/reports?error=D%E1%BB%AF+li%E1%BB%87u+kh%C3%B4ng+h%E1%BB%A3p+l%E1%BB%87");
        }
    }
}
