package codegym.vn.internmanagement.controller.intern;

import codegym.vn.internmanagement.dao.ContractDAO;
import codegym.vn.internmanagement.dao.InternDAO;
import codegym.vn.internmanagement.entity.Contract;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Intern contract view & confirmation.
 * GET  /intern/contracts         - view own contracts
 * POST /intern/contracts/confirm - confirm a pending contract
 */
@WebServlet(urlPatterns = {"/intern/contracts", "/intern/contracts/confirm"})
public class InternContractServlet extends HttpServlet {

    private ContractDAO contractDAO;
    private InternDAO   internDAO;

    @Override
    public void init() {
        contractDAO = new ContractDAO();
        internDAO   = new InternDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Intern intern = getIntern(request);
        List<Contract> contracts = intern != null
                ? contractDAO.findByInternId(intern.getId())
                : new ArrayList<>();
        request.setAttribute("intern",    intern);
        request.setAttribute("contracts", contracts);
        request.getRequestDispatcher("/WEB-INF/views/intern/contracts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if ("/intern/contracts/confirm".equals(request.getServletPath())) {
            Long id = parseLong(request.getParameter("id"));
            if (id != null) contractDAO.confirm(id);
        }
        response.sendRedirect(request.getContextPath() + "/intern/contracts");
    }

    private Intern getIntern(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("currentUser");
        return user != null ? internDAO.findByUserId(user.getId()) : null;
    }

    private Long parseLong(String val) {
        try { return val != null && !val.isBlank() ? Long.parseLong(val) : null; }
        catch (NumberFormatException e) { return null; }
    }
}
