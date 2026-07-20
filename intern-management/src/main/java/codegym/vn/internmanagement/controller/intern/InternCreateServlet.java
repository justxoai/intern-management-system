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
 * Controller handling creation of intern profiles by HR.
 * GET  /hr/interns/create -> Display intern profile form
 * POST /hr/interns/create -> Process form data, validate, insert, redirect to intern list
 */
@WebServlet("/hr/interns/create")
public class InternCreateServlet extends HttpServlet {

    private InternModel internModel;

    @Override
    public void init() {
        internModel = new InternModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentCode = request.getParameter("studentCode");
        String university = request.getParameter("university");
        String major = request.getParameter("major");
        String dobStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String status = request.getParameter("status");
        String userIdStr = request.getParameter("userId");

        Intern intern = new Intern();
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
        intern.setStatus(status != null ? status : "PENDING");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            intern.setUserId(Long.parseLong(userIdStr));
        }

        String error = internModel.createIntern(intern);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/interns");
        }
    }
}
