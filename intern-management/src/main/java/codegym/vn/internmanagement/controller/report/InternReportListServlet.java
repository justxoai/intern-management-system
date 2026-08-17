package codegym.vn.internmanagement.controller.report;

import codegym.vn.internmanagement.dao.InternDAO;
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
import java.util.List;

@WebServlet("/intern/reports")
public class InternReportListServlet extends HttpServlet {

    private InternDAO internDAO = new InternDAO();
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"INTERN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Intern intern = internDAO.findByUserId(user.getId());
        if (intern != null) {
            List<WeeklyReport> reports = reportDAO.getReportsByInternId(intern.getId());
            request.setAttribute("reports", reports);
        }

        request.getRequestDispatcher("/WEB-INF/views/intern/report_list.jsp").forward(request, response);
    }
}
