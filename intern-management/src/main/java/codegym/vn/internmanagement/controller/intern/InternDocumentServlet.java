package codegym.vn.internmanagement.controller.intern;

import codegym.vn.internmanagement.dao.DocumentDAO;
import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Document;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;

/**
 * Intern document management: upload CV / internship application, view status.
 * GET  /intern/documents          - view own documents
 * POST /intern/documents/upload   - upload a new document
 * POST /intern/documents/delete   - delete a pending document
 */
@WebServlet(urlPatterns = {"/intern/documents", "/intern/documents/upload", "/intern/documents/delete"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB in-memory threshold
        maxFileSize       = 10 * 1024 * 1024, // 10 MB max per file
        maxRequestSize    = 20 * 1024 * 1024  // 20 MB max total
)
public class InternDocumentServlet extends HttpServlet {

    private InternDAO internDAO;
    private DocumentDAO documentDAO;

    @Override
    public void init() {
        internDAO   = new InternDAO();
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Intern intern = getIntern(request);
        if (intern == null) {
            request.setAttribute("error", "No intern profile found for your account. Please contact HR.");
            request.getRequestDispatcher("/WEB-INF/views/intern/documents.jsp").forward(request, response);
            return;
        }
        List<Document> docs = documentDAO.findByInternId(intern.getId());
        request.setAttribute("intern", intern);
        request.setAttribute("documents", docs);
        request.getRequestDispatcher("/WEB-INF/views/intern/documents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/intern/documents/upload".equals(path)) {
            handleUpload(request, response);
        } else if ("/intern/documents/delete".equals(path)) {
            handleDelete(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/intern/documents");
        }
    }

    // ── Upload ───────────────────────────────────────────────────────────

    private void handleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Intern intern = getIntern(request);
        if (intern == null) {
            response.sendRedirect(request.getContextPath() + "/intern/documents");
            return;
        }

        String docType = request.getParameter("documentType");
        Part filePart  = request.getPart("file");
        String originalName = extractFileName(filePart);

        if (originalName == null || originalName.isBlank()) {
            redirectWithMsg(request, response, "error", "Please select a file to upload.");
            return;
        }

        // Validate extension
        String lower = originalName.toLowerCase();
        if (!lower.endsWith(".pdf") && !lower.endsWith(".doc") && !lower.endsWith(".docx")) {
            redirectWithMsg(request, response, "error", "Only PDF, DOC, DOCX files are accepted.");
            return;
        }

        // Build storage path: <webapp>/uploads/documents/<internId>/
        String uploadDir = getServletContext().getRealPath("/uploads/documents/" + intern.getId());
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // Unique filename to avoid conflicts
        String safeBase = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String storedName = System.currentTimeMillis() + "_" + safeBase;
        File destFile = new File(uploadDir, storedName);
        filePart.write(destFile.getAbsolutePath());

        // Relative web path
        String webPath = "/uploads/documents/" + intern.getId() + "/" + storedName;

        Document doc = new Document();
        doc.setInternId(intern.getId());
        doc.setDocumentType(docType);
        doc.setFileName(originalName);
        doc.setFilePath(webPath);

        boolean ok = documentDAO.insert(doc);
        if (ok) {
            redirectWithMsg(request, response, "success", "Document uploaded successfully! Awaiting HR review.");
        } else {
            redirectWithMsg(request, response, "error", "Failed to save document record. Please try again.");
        }
    }

    // ── Delete ───────────────────────────────────────────────────────────

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try { documentDAO.delete(Long.parseLong(idStr)); } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/intern/documents");
    }

    // ── Helpers ──────────────────────────────────────────────────────────

    private Intern getIntern(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return null;
        return internDAO.findByUserId(user.getId());
    }

    private String extractFileName(Part part) {
        if (part == null) return null;
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // IE may send full path
                int last = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return last >= 0 ? name.substring(last + 1) : name;
            }
        }
        return null;
    }

    private void redirectWithMsg(HttpServletRequest req, HttpServletResponse res, String key, String msg)
            throws IOException {
        res.sendRedirect(req.getContextPath() + "/intern/documents?" + key + "=" +
                java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
    }
}
