package codegym.vn.internmanagement.controller.intern;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.model.InternModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Controller handling editing of intern profiles by HR.
 * GET  /hr/interns/edit?id=1 -> Display edit form populated with current profile
 * POST /hr/interns/edit -> Process profile updates and redirect to intern list
 */
@WebServlet("/hr/interns/edit")
public class InternEditServlet extends HttpServlet {

    private InternModel internModel;

    @Override
    public void init() {
        internModel = new InternModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String studentCode = request.getParameter("studentCode");
        String university = request.getParameter("university");
        String major = request.getParameter("major");
        String dobStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        Long id = Long.parseLong(idStr);
        Intern intern = internModel.getInternById(id);

        if (intern != null) {
            intern.setStudentCode(studentCode);
            intern.setUniversity(university);
            intern.setMajor(major);
            if (dobStr != null && !dobStr.isEmpty()) {
                intern.setDateOfBirth(LocalDate.parse(dobStr));
            }
            intern.setGender(gender);
            intern.setAddress(address);
            intern.setPhone(phone);
            intern.setEmail(email);
            intern.setStatus(status);

            String error = internModel.updateIntern(intern);

            if (error != null) {
                request.setAttribute("error", error);
                request.setAttribute("intern", intern);
                request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp")
                        .forward(request, response);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/hr/interns");
    }
}
