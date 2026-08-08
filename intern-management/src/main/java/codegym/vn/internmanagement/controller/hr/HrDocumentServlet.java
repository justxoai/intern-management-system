package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.DocumentDAO;
import codegym.vn.internmanagement.entity.Document;
import codegym.vn.internmanagement.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * HR document review: view all intern documents, approve or reject.
 * GET  /hr/documents          - list all documents with optional status filter
 * POST /hr/documents/review   - approve or reject a document
 */
@WebServlet(urlPatterns = {"/hr/documents", "/hr/documents/review"})
public class HrDocumentServlet extends HttpServlet {

    private DocumentDAO documentDAO;

    @Override
    public void init() {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        List<Document> docs = documentDAO.findAll(statusFilter);

        request.setAttribute("documents",    docs);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.getRequestDispatcher("/WEB-INF/views/hr/documents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if ("/hr/documents/review".equals(request.getServletPath())) {
            String idStr    = request.getParameter("id");
            String action   = request.getParameter("action"); // APPROVED or REJECTED
            Long reviewerId = getCurrentUserId(request);

            if (idStr != null && reviewerId != null &&
                ("APPROVED".equals(action) || "REJECTED".equals(action))) {
                try {
                    documentDAO.updateStatus(Long.parseLong(idStr), action, reviewerId);
                } catch (NumberFormatException ignored) {}
            }
        }
        response.sendRedirect(request.getContextPath() + "/hr/documents");
    }

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("currentUser");
        return user != null ? user.getId() : null;
    }
}
