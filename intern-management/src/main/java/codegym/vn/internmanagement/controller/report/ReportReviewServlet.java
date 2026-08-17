package codegym.vn.internmanagement.controller.report;

import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.dao.ReportDAO;
import codegym.vn.internmanagement.entity.Mentor;
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

@WebServlet("/mentor/reports")
public class ReportReviewServlet extends HttpServlet {

    private MentorDAO mentorDAO = new MentorDAO();
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MENTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("view".equals(action)) {
            Long reportId = Long.parseLong(request.getParameter("id"));
            WeeklyReport report = reportDAO.getReportById(reportId);
            request.setAttribute("report", report);
            request.getRequestDispatcher("/WEB-INF/views/mentor/report_review.jsp").forward(request, response);
        } else {
            Mentor mentor = mentorDAO.findByUserId(user.getId());
            if (mentor != null) {
                List<WeeklyReport> reports = reportDAO.getReportsByMentorId(mentor.getId());
                request.setAttribute("reports", reports);
            }
            request.getRequestDispatcher("/WEB-INF/views/mentor/report_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MENTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long reportId = Long.parseLong(request.getParameter("id"));
            String feedback = request.getParameter("feedback");

            WeeklyReport report = reportDAO.getReportById(reportId);
            if (report != null) {
                report.setFeedback(feedback);
                if (reportDAO.updateReportFeedback(report)) {
                    response.sendRedirect(request.getContextPath() + "/mentor/reports?message=Feedback+submitted");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/mentor/reports?error=Failed+to+submit+feedback");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/mentor/reports?error=Invalid+report+ID");
        }
    }
}
