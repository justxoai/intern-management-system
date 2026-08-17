package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.ApplicationDAO;
import codegym.vn.internmanagement.entity.Application;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * HR — Internship Application Review. (#12)
 *
 * GET  /hr/applications               — list all applications (with optional status filter)
 * POST /hr/applications/approve       — approve application + send email (#13)
 * POST /hr/applications/reject        — reject application + send email (#13)
 */
@WebServlet(urlPatterns = {"/hr/applications", "/hr/applications/approve", "/hr/applications/reject"})
public class HrApplicationServlet extends HttpServlet {

    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = nullToEmpty(request.getParameter("status"));
        List<Application> applications = applicationDAO.findAll(
                statusFilter.isEmpty() ? null : statusFilter);
        long pendingCount = applicationDAO.countPending();

        request.setAttribute("applications",  applications);
        request.setAttribute("statusFilter",  statusFilter);
        request.setAttribute("pendingCount",  pendingCount);
        request.getRequestDispatcher("/WEB-INF/views/hr/applications.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        switch (request.getServletPath()) {
            case "/hr/applications/approve" -> handleApprove(request, response);
            case "/hr/applications/reject"  -> handleReject(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/hr/applications");
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long appId = parseLong(request.getParameter("id"));
        User reviewer = currentUser(request);
        if (appId != null && reviewer != null) {
            applicationDAO.approve(appId, reviewer.getId());
            // Send email notification (#13)
            Application app = applicationDAO.findById(appId);
            if (app != null && app.getInternEmail() != null) {
                new Thread(() -> EmailService.sendApprovalEmail(
                        app.getInternEmail(), app.getInternName())).start();
            }
        }
        response.sendRedirect(request.getContextPath() + "/hr/applications?success=Application+approved");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long appId = parseLong(request.getParameter("id"));
        String reason = nullToEmpty(request.getParameter("reason"));
        User reviewer = currentUser(request);
        if (appId != null && reviewer != null) {
            applicationDAO.reject(appId, reviewer.getId(), reason);
            // Send email notification (#13)
            Application app = applicationDAO.findById(appId);
            if (app != null && app.getInternEmail() != null) {
                String finalReason = reason;
                new Thread(() -> EmailService.sendRejectionEmail(
                        app.getInternEmail(), app.getInternName(), finalReason)).start();
            }
        }
        response.sendRedirect(request.getContextPath() + "/hr/applications?success=Application+rejected");
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
