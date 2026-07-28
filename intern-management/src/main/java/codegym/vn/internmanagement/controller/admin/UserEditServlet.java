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
 * Controller handling editing of user accounts by ADMIN.
 * GET  /admin/users/edit?id={id} -> Display edit form
 * POST /admin/users/edit        -> Process update, validate, save, and redirect
 */
@WebServlet("/admin/users/edit")
public class UserEditServlet extends HttpServlet {

    private UserModel userModel;

    @Override
    public void init() {
        userModel = new UserModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            User user = userModel.getUserById(id);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/admin/users/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            String fullName = request.getParameter("fullName");
            String email    = request.getParameter("email");
            String phone    = request.getParameter("phone");
            String role     = request.getParameter("role");
            String status   = request.getParameter("status");

            User user = new User();
            user.setId(id);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setStatus(status);

            String error = userModel.updateUser(user);
            if (error != null) {
                request.setAttribute("error", error);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/admin/users/edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
