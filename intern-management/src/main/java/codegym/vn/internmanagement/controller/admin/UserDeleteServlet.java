package codegym.vn.internmanagement.controller.admin;

import codegym.vn.internmanagement.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller handling deletion of user accounts by ADMIN.
 * POST /admin/users/delete?id={id} -> Delete user and redirect
 */
@WebServlet("/admin/users/delete")
public class UserDeleteServlet extends HttpServlet {

    private UserModel userModel;

    @Override
    public void init() {
        userModel = new UserModel();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long id = Long.parseLong(idParam);
                userModel.deleteUser(id);
            } catch (NumberFormatException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
