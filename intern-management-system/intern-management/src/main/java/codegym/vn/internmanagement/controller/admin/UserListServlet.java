package codegym.vn.internmanagement.controller.admin;

import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller handling user list viewing for ADMIN.
 * GET /admin/users
 */
@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {

    private UserModel userModel;

    @Override
    public void init() {
        userModel = new UserModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userModel.getAllUsers();
        request.setAttribute("users", users);

        request.getRequestDispatcher("/WEB-INF/views/admin/users/list.jsp")
                .forward(request, response);
    }
}
