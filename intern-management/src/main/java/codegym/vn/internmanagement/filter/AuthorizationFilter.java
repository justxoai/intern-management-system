package codegym.vn.internmanagement.filter;

import java.io.IOException;

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

/**
 * Filter handling role-based authorization for administrative and user endpoints.
 * URL permission rules:
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

        if (isUnder(path, "/hr") && !hasRole(role, "ADMIN", "HR")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "HR access required.");
            return;
        }

        if (isUnder(path, "/mentor") && !hasRole(role, "ADMIN", "MENTOR")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Mentor access required.");
            return;
        }

        if (isUnder(path, "/intern") && !hasRole(role, "ADMIN", "INTERN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Intern access required.");
            return;
        }

        chain.doFilter(req, res);
    }

    private boolean isUnder(String path, String area) {
        return path.equals(area) || path.startsWith(area + "/");
    }

    private boolean hasRole(String role, String... allowedRoles) {
        for (String allowedRole : allowedRoles) {
            if (allowedRole.equals(role)) {
                return true;
            }
        }
        return false;
    }
}
