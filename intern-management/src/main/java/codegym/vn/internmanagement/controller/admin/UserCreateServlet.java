package codegym.vn.internmanagement.controller.admin;

import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller handling creation of user accounts (HR, MENTOR, INTERN) by ADMIN.
 * GET  /admin/users/create -> Display user creation form
 * POST /admin/users/create -> Process form submission, validate, save, and redirect
 */
@WebServlet("/admin/users/create")
public class UserCreateServlet extends HttpServlet {

    private UserModel userModel;

    @Override
    public void init() {
        userModel = new UserModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/users/create.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        User user = new User(username, password, fullName, email, phone, role, "ACTIVE");

        String error = userModel.createUser(user);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/admin/users/create.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
