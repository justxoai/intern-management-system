package codegym.vn.internmanagement.controller.mentor;

import codegym.vn.internmanagement.dao.MentorDAO;
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
import java.util.List;

@WebServlet(urlPatterns = {"/mentor/reports", "/mentor/reports/feedback"})
public class MentorReportServlet extends HttpServlet {

    private WeeklyReportDAO reportDAO;
    private MentorDAO mentorDAO;

    @Override
    public void init() {
        reportDAO = new WeeklyReportDAO();
        mentorDAO = new MentorDAO();
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
        List<WeeklyReport> allReports = reportDAO.findByMentorUserId(mentorUserId);
        List<Intern> allMyInterns = mentorDAO.findInternsByMentorUserId(mentorUserId);

        String statusFilter = request.getParameter("status");
        String internIdFilter = request.getParameter("internId");

        List<WeeklyReport> reports = allReports;
        if (statusFilter != null && !statusFilter.isBlank()) {
            reports = reports.stream().filter(r -> statusFilter.equalsIgnoreCase(r.getStatus())).toList();
        }
        if (internIdFilter != null && !internIdFilter.isBlank()) {
            try {
                long iId = Long.parseLong(internIdFilter.trim());
                reports = reports.stream().filter(r -> r.getInternId() != null && r.getInternId() == iId).toList();
            } catch (Exception ignored) {}
        }

        long pendingFeedbackCount = allReports.stream().filter(r -> "SUBMITTED".equalsIgnoreCase(r.getStatus())).count();
        long reviewedCount = allReports.stream().filter(r -> "REVIEWED".equalsIgnoreCase(r.getStatus())).count();

        request.setAttribute("reports", reports);
        request.setAttribute("allReports", allReports);
        request.setAttribute("allMyInterns", allMyInterns);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.setAttribute("internIdFilter", internIdFilter != null ? internIdFilter : "");
        request.setAttribute("pendingFeedbackCount", pendingFeedbackCount);
        request.setAttribute("reviewedCount", reviewedCount);

        request.getRequestDispatcher("/WEB-INF/views/mentor/reports.jsp").forward(request, response);
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

        String path = request.getServletPath();
        if ("/mentor/reports/feedback".equals(path)) {
            String idStr = request.getParameter("id");
            String feedback = request.getParameter("feedback");

            Long reportId = null;
            try {
                if (idStr != null && !idStr.isBlank()) reportId = Long.parseLong(idStr.trim());
            } catch (Exception ignored) {}

            if (reportId != null && feedback != null && !feedback.isBlank()) {
                boolean ok = reportDAO.saveFeedback(reportId, feedback.trim());
                if (ok) {
                    response.sendRedirect(request.getContextPath() + "/mentor/reports?success=G%E1%BB%ADi+ph%E1%BA%A3n+h%E1%BB%93i+th%C3%A0nh+c%C3%B4ng");
                } else {
                    response.sendRedirect(request.getContextPath() + "/mentor/reports?error=Kh%C3%B4ng+th%E1%BB%83+l%C6%B0u+ph%E1%BA%A3n+h%E1%BB%93i");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/mentor/reports?error=Vui+l%C3%B2ng+nh%E1%BA%ADp+n%E1%BB%99i+dung+ph%E1%BA%A3n+h%E1%BB%93i");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/mentor/reports");
        }
    }
}
