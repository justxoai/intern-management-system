package codegym.vn.internmanagement.controller.intern;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.model.InternModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/hr/interns", "/hr/interns/create", "/hr/interns/edit", "/hr/interns/delete"})
public class InternController extends HttpServlet {

    private InternModel internModel;

    @Override
    public void init() {
        internModel = new InternModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/hr/interns/create".equals(path)) {
            showCreateForm(request, response);
        } else if ("/hr/interns/edit".equals(path)) {
            showEditForm(request, response);
        } else if ("/hr/interns/delete".equals(path)) {
            deleteIntern(request, response);
        } else {
            listInterns(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/hr/interns/create".equals(path)) {
            createIntern(request, response);
        } else if ("/hr/interns/edit".equals(path)) {
            updateIntern(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void listInterns(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String university = request.getParameter("university");
        String major = request.getParameter("major");
        String status = request.getParameter("status");

        List<Intern> interns = internModel.searchInterns(keyword, university, major, status);

        request.setAttribute("interns", interns);
        request.setAttribute("keyword", keyword);
        request.setAttribute("university", university);
        request.setAttribute("major", major);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/WEB-INF/views/intern/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/interns");
            return;
        }

        Long id = Long.parseLong(idStr);
        Intern intern = internModel.getInternById(id);

        if (intern == null) {
            response.sendRedirect(request.getContextPath() + "/hr/interns");
            return;
        }

        request.setAttribute("intern", intern);
        request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp").forward(request, response);
    }

    private void deleteIntern(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            internModel.deleteIntern(id);
        }
        response.sendRedirect(request.getContextPath() + "/hr/interns");
    }

    private void createIntern(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Intern intern = new Intern();
        intern.setStudentCode(request.getParameter("studentCode"));
        intern.setUniversity(request.getParameter("university"));
        intern.setMajor(request.getParameter("major"));
        String dobStr = request.getParameter("dateOfBirth");
        if (dobStr != null && !dobStr.isEmpty()) {
            intern.setDateOfBirth(LocalDate.parse(dobStr));
        }
        intern.setGender(request.getParameter("gender"));
        intern.setAddress(request.getParameter("address"));
        intern.setPhone(request.getParameter("phone"));
        intern.setEmail(request.getParameter("email"));
        String status = request.getParameter("status");
        intern.setStatus(status != null ? status : "PENDING");
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            intern.setUserId(Long.parseLong(userIdStr));
        }

        String error = internModel.createIntern(intern);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/interns");
        }
    }

    private void updateIntern(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Long id = Long.parseLong(idStr);
        Intern intern = internModel.getInternById(id);

        if (intern != null) {
            intern.setStudentCode(request.getParameter("studentCode"));
            intern.setUniversity(request.getParameter("university"));
            intern.setMajor(request.getParameter("major"));
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                intern.setDateOfBirth(LocalDate.parse(dobStr));
            }
            intern.setGender(request.getParameter("gender"));
            intern.setAddress(request.getParameter("address"));
            intern.setPhone(request.getParameter("phone"));
            intern.setEmail(request.getParameter("email"));
            intern.setStatus(request.getParameter("status"));

            String error = internModel.updateIntern(intern);

            if (error != null) {
                request.setAttribute("error", error);
                request.setAttribute("intern", intern);
                request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/hr/interns");
    }
}
