package codegym.vn.internmanagement.controller.report;

import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.dao.ReportDAO;
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

@WebServlet("/intern/report/submit")
public class ReportSubmitServlet extends HttpServlet {

    private InternDAO internDAO = new InternDAO();
    private MentorDAO mentorDAO = new MentorDAO();
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"INTERN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/intern/report_submit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"INTERN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int weekNumber = Integer.parseInt(request.getParameter("weekNumber"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            Intern intern = internDAO.findByUserId(user.getId());
            if (intern == null) {
                request.setAttribute("error", "Intern record not found.");
                request.getRequestDispatcher("/WEB-INF/views/intern/report_submit.jsp").forward(request, response);
                return;
            }

            Long mentorId = mentorDAO.getAssignedMentorId(intern.getId());
            if (mentorId == null) {
                request.setAttribute("error", "You do not have an assigned mentor yet.");
                request.getRequestDispatcher("/WEB-INF/views/intern/report_submit.jsp").forward(request, response);
                return;
            }

            WeeklyReport report = new WeeklyReport();
            report.setInternId(intern.getId());
            report.setMentorId(mentorId);
            report.setWeekNumber(weekNumber);
            report.setTitle(title);
            report.setContent(content);

            if (reportDAO.insertReport(report)) {
                response.sendRedirect(request.getContextPath() + "/intern/home?message=Report+submitted+successfully");
            } else {
                request.setAttribute("error", "Failed to submit report.");
                request.getRequestDispatcher("/WEB-INF/views/intern/report_submit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid week number.");
            request.getRequestDispatcher("/WEB-INF/views/intern/report_submit.jsp").forward(request, response);
        }
    }
}
