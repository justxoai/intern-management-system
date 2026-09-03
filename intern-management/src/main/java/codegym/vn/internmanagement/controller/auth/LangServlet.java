package codegym.vn.internmanagement.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Chuyển đổi ngôn ngữ giao diện.
 *
 * GET /lang?lang=vi  — chuyển sang Tiếng Việt
 * GET /lang?lang=en  — chuyển sang English
 *
 * Sau khi đổi, redirect về trang trước (Referer) hoặc về trang chủ.
 */
@WebServlet("/lang")
public class LangServlet extends HttpServlet {

    private static final Set<String> SUPPORTED = Set.of("vi", "en");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String lang = request.getParameter("lang");
        if (lang != null && SUPPORTED.contains(lang.trim().toLowerCase())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("lang", lang.trim().toLowerCase());
        }

        // Redirect về trang trước, nếu không có thì về contextPath
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
