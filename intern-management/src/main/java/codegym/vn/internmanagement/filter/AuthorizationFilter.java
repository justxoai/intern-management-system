package codegym.vn.internmanagement.filter;

import codegym.vn.internmanagement.entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter handling role-based authorization for administrative and user endpoints.
 * URL Permission Rules:
 * - /admin/* -> ADMIN only
 * - /hr/* -> ADMIN or HR
 * - /mentor/* -> ADMIN or MENTOR
 * - /intern/* -> ADMIN or INTERN
 */
@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Skip static assets or public auth endpoints
        if (path.startsWith("/assets/") || path.equals("/login") || path.equals("/logout") || path.equals("/index.jsp") || path.equals("/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        String role = currentUser.getRole();

        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
            return;
        }

        if (path.startsWith("/hr/") && !"ADMIN".equals(role) && !"HR".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: HR role required.");
            return;
        }

        if (path.startsWith("/mentor/") && !"ADMIN".equals(role) && !"MENTOR".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Mentor role required.");
            return;
        }

        if (path.startsWith("/intern/") && !"ADMIN".equals(role) && !"INTERN".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Intern role required.");
            return;
        }

        chain.doFilter(req, res);
    }
}
