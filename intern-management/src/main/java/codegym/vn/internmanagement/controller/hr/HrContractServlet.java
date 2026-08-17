package codegym.vn.internmanagement.controller.hr;

import codegym.vn.internmanagement.dao.ContractDAO;
import codegym.vn.internmanagement.dao.DocumentDAO;
import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Contract;
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
import java.time.LocalDate;
import java.util.List;

/**
 * HR Contract management — upload contracts for interns, view all contracts.
 * GET  /hr/contracts           - list all contracts
 * POST /hr/contracts/upload    - upload contract file + create contract record
 * POST /hr/contracts/cancel    - cancel a contract
 */
@WebServlet(urlPatterns = {"/hr/contracts", "/hr/contracts/upload", "/hr/contracts/cancel"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 10 * 1024 * 1024,
        maxRequestSize    = 20 * 1024 * 1024
)
public class HrContractServlet extends HttpServlet {

    private ContractDAO contractDAO;
    private DocumentDAO documentDAO;
    private InternDAO   internDAO;

    @Override
    public void init() {
        contractDAO = new ContractDAO();
        documentDAO = new DocumentDAO();
        internDAO   = new InternDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        List<Contract> contracts = contractDAO.findAll(statusFilter);
        List<Intern>   interns   = internDAO.search(null, null, null, null);

        request.setAttribute("contracts",    contracts);
        request.setAttribute("interns",      interns);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.getRequestDispatcher("/WEB-INF/views/hr/contracts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getServletPath()) {
            case "/hr/contracts/upload" -> handleUpload(request, response);
            case "/hr/contracts/cancel" -> handleCancel(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/hr/contracts");
        }
    }

    // ── Upload Contract ────────────────────────────────────────────────

    private void handleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long internId = parseLong(request.getParameter("internId"));
        String startDateStr = request.getParameter("startDate");
        String endDateStr   = request.getParameter("endDate");
        Part filePart = request.getPart("file");
        String originalName = extractFileName(filePart);

        if (internId == null || originalName == null || originalName.isBlank()) {
            redirectErr(request, response, "Please select an intern and a contract file.");
            return;
        }
        if (startDateStr == null || startDateStr.isBlank() || endDateStr == null || endDateStr.isBlank()) {
            redirectErr(request, response, "Start date and end date are required.");
            return;
        }

        String lower = originalName.toLowerCase();
        if (!lower.endsWith(".pdf") && !lower.endsWith(".doc") && !lower.endsWith(".docx")) {
            redirectErr(request, response, "Only PDF, DOC, DOCX files are accepted.");
            return;
        }

        // Store file
        String uploadDir = getServletContext().getRealPath("/uploads/contracts/" + internId);
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String storedName = System.currentTimeMillis() + "_" + originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        filePart.write(new File(uploadDir, storedName).getAbsolutePath());
        String webPath = "/uploads/contracts/" + internId + "/" + storedName;

        // Save document record (type=CONTRACT)
        Document doc = new Document();
        doc.setInternId(internId);
        doc.setDocumentType("CONTRACT");
        doc.setFileName(originalName);
        doc.setFilePath(webPath);
        doc.setStatus("PENDING");
        long docId = documentDAO.insertAndGetId(doc);

        // Create contract record
        Contract contract = new Contract();
        contract.setInternId(internId);
        contract.setDocumentId(docId > 0 ? docId : null);
        contract.setStartDate(LocalDate.parse(startDateStr));
        contract.setEndDate(LocalDate.parse(endDateStr));
        contractDAO.insert(contract);

        response.sendRedirect(request.getContextPath() + "/hr/contracts?success=Contract+uploaded+successfully");
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = parseLong(request.getParameter("id"));
        if (id != null) contractDAO.cancel(id);
        response.sendRedirect(request.getContextPath() + "/hr/contracts");
    }

    // ── helpers ───────────────────────────────────────────────────────

    private String extractFileName(Part part) {
        if (part == null) return null;
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int last = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return last >= 0 ? name.substring(last + 1) : name;
            }
        }
        return null;
    }

    private Long parseLong(String val) {
        try { return val != null && !val.isBlank() ? Long.parseLong(val) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private void redirectErr(HttpServletRequest req, HttpServletResponse res, String msg) throws IOException {
        res.sendRedirect(req.getContextPath() + "/hr/contracts?error=" +
                java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
    }
}
