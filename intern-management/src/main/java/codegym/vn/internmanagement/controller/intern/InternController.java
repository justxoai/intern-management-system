package codegym.vn.internmanagement.controller.intern;

import java.io.IOException;
import java.time.LocalDate;

import codegym.vn.internmanagement.dao.UserDAO;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.InternModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/hr/interns", "/hr/interns/create", "/hr/interns/edit", "/hr/interns/delete"})
public class InternController extends HttpServlet {

    private InternModel internModel;
    private UserDAO userDAO;

    @Override
    public void init() {
        internModel = new InternModel();
        userDAO = new UserDAO();
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
            response.sendRedirect(request.getContextPath() + "/hr/dashboard");
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

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/dashboard");
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            Intern intern = internModel.getInternById(id);

            if (intern == null) {
                response.sendRedirect(request.getContextPath() + "/hr/dashboard");
                return;
            }

            if (intern.getUserId() != null && intern.getUserId() > 0) {
                User user = userDAO.findById(intern.getUserId());
                if (user != null) {
                    request.setAttribute("user", user);
                    if (intern.getFullName() == null || intern.getFullName().isBlank()) {
                        intern.setFullName(user.getFullName());
                    }
                }
            }

            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/hr/dashboard");
        }
    }

    private void deleteIntern(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Long id = Long.parseLong(idStr.trim());
                internModel.deleteIntern(id);
            } catch (Exception ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/hr/dashboard?success=Intern+profile+deleted");
    }

    private void createIntern(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Intern intern = new Intern();
        intern.setStudentCode(trim(request.getParameter("studentCode")));
        intern.setUniversity(trim(request.getParameter("university")));
        intern.setMajor(trim(request.getParameter("major")));
        String dobStr = trim(request.getParameter("dateOfBirth"));
        if (!dobStr.isEmpty()) {
            try { intern.setDateOfBirth(LocalDate.parse(dobStr)); } catch (Exception ignored) {}
        }
        intern.setGender(trim(request.getParameter("gender")));
        intern.setAddress(trim(request.getParameter("address")));
        intern.setPhone(trim(request.getParameter("phone")));
        intern.setEmail(trim(request.getParameter("email")));
        intern.setFullName(trim(request.getParameter("fullName")));
        String status = trim(request.getParameter("status"));
        intern.setStatus(!status.isEmpty() ? status : "PENDING");

        String userIdStr = trim(request.getParameter("userId"));
        if (!userIdStr.isEmpty()) {
            try { intern.setUserId(Long.parseLong(userIdStr)); } catch (Exception ignored) {}
        }

        String username = trim(request.getParameter("username"));
        String password = trim(request.getParameter("password"));
        request.setAttribute("internUsername", username);
        request.setAttribute("internPassword", password);

        // Basic validation
        if (intern.getFullName() == null || intern.getFullName().isEmpty()) {
            request.setAttribute("error", "Full Name is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }
        if (intern.getEmail() == null || intern.getEmail().isEmpty()) {
            request.setAttribute("error", "Email is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }
        if (intern.getPhone() == null || intern.getPhone().isEmpty()) {
            request.setAttribute("error", "Phone is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }
        if (intern.getGender() == null || intern.getGender().isEmpty()) {
            request.setAttribute("error", "Gender is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }
        if (intern.getUniversity() == null || intern.getUniversity().isEmpty()) {
            request.setAttribute("error", "University is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }
        if (intern.getMajor() == null || intern.getMajor().isEmpty()) {
            request.setAttribute("error", "Major is required.");
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
            return;
        }

        String error = internModel.createIntern(intern, username, password);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("intern", intern);
            request.getRequestDispatcher("/WEB-INF/views/intern/create.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/dashboard?success=Intern+profile+created");
        }
    }

    private void updateIntern(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = trim(request.getParameter("id"));
        if (idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/dashboard");
            return;
        }

        try {
            Long id = Long.parseLong(idStr);
            Intern intern = internModel.getInternById(id);

            if (intern == null) {
                response.sendRedirect(request.getContextPath() + "/hr/dashboard");
                return;
            }

            intern.setFullName(trim(request.getParameter("fullName")));
            intern.setEmail(trim(request.getParameter("email")));
            intern.setPhone(trim(request.getParameter("phone")));
            String dobStr = trim(request.getParameter("dateOfBirth"));
            if (!dobStr.isEmpty()) {
                try { intern.setDateOfBirth(LocalDate.parse(dobStr)); } catch (Exception ignored) {}
            } else {
                intern.setDateOfBirth(null);
            }
            intern.setGender(trim(request.getParameter("gender")));
            intern.setStudentCode(trim(request.getParameter("studentCode")));
            intern.setStatus(trim(request.getParameter("status")));
            intern.setUniversity(trim(request.getParameter("university")));
            intern.setMajor(trim(request.getParameter("major")));
            intern.setAddress(trim(request.getParameter("address")));

            String username = trim(request.getParameter("username"));
            String password = trim(request.getParameter("password"));

            String error = internModel.updateIntern(intern, username, password);

            if (error != null) {
                request.setAttribute("error", error);
                request.setAttribute("intern", intern);
                User user = new User();
                user.setUsername(username);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/intern/edit.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/hr/dashboard?success=Intern+profile+updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/hr/dashboard");
        }
    }

    private String trim(String v) {
        return v == null ? "" : v.trim();
    }
}
