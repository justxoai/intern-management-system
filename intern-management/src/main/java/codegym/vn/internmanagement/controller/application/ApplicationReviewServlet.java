package codegym.vn.internmanagement.controller.application;

import codegym.vn.internmanagement.dao.ApplicationDAO;
import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.InternshipApplication;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/hr/applications")
public class ApplicationReviewServlet extends HttpServlet {

    private ApplicationDAO applicationDAO = new ApplicationDAO();
    private InternDAO internDAO = new InternDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"HR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<InternshipApplication> applications = applicationDAO.getAllApplications();
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/WEB-INF/views/hr/application_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"HR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long appId = Long.parseLong(request.getParameter("id"));
            String status = request.getParameter("status"); // APPROVED or REJECTED
            String reason = request.getParameter("reason");

            InternshipApplication app = applicationDAO.getApplicationById(appId);

            if (app != null && ("APPROVED".equals(status) || "REJECTED".equals(status))) {
                if (applicationDAO.updateApplicationStatus(appId, status, user.getId(), reason)) {
                    
                    // Send Email Notification
                    Intern intern = internDAO.findById(app.getInternId());
                    if (intern != null) {
                        User internUser = userDAO.findById(intern.getUserId());
                        if (internUser != null) {
                            String subject = "Internship Application Result";
                            String body = "Dear " + internUser.getFullName() + ",\n\n" +
                                    "Your internship application has been " + status + ".\n";
                            if ("REJECTED".equals(status) && reason != null && !reason.isEmpty()) {
                                body += "Reason: " + reason + "\n";
                            }
                            body += "\nBest regards,\nHR Department";
                            
                            EmailUtil.sendEmail(internUser.getEmail(), subject, body);
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/hr/applications?message=Application+" + status);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/hr/applications?error=Failed+to+update+application");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/hr/applications?error=Invalid+ID");
        }
    }
}
