package codegym.vn.internmanagement.controller.auth;

import java.io.IOException;

import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserModel userModel = new UserModel();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userModel.authenticate(username, password);
        if (user == null) {
            request.setAttribute("error", "Invalid username or password.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        String landingPage = switch (user.getRole()) {
            case "ADMIN", "HR" -> "/hr/interns";
            case "INTERN" -> "/intern";
            case "MENTOR" -> "/mentor/reports";
            default -> "/login";
        };
        response.sendRedirect(request.getContextPath() + landingPage);
    }
}
