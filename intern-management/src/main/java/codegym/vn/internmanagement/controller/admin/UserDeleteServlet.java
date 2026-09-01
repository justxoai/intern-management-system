package codegym.vn.internmanagement.controller.admin;

import codegym.vn.internmanagement.entity.User;
import codegym.vn.internmanagement.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * ADMIN — Xóa tài khoản người dùng.
 *
 * POST /admin/users/delete
 *   Param: id (Long) — ID của user cần xóa
 *
 * Lưu ý bảo vệ:
 *  - Không cho phép xóa chính tài khoản đang đăng nhập.
 *  - Không cho phép xóa tài khoản ADMIN khác.
 *  - DB schema đã khai báo ON DELETE CASCADE nên các bảng
 *    interns, mentors, internship_applications,... sẽ tự dọn.
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
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid+user+ID");
            return;
        }

        long targetId;
        try {
            targetId = Long.parseLong(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid+user+ID");
            return;
        }

        // Bảo vệ: không cho xóa chính mình
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser != null && currentUser.getId() == targetId) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Cannot+delete+your+own+account");
            return;
        }

        // Bảo vệ: không cho xóa tài khoản ADMIN khác
        User target = userModel.getUserById(targetId);
        if (target == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=User+not+found");
            return;
        }
        if ("ADMIN".equals(target.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Cannot+delete+an+ADMIN+account");
            return;
        }

        // Xóa — CASCADE tự dọn interns/mentors/applications/documents/...
        boolean deleted = userModel.deleteUser(targetId);
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed+to+delete+user");
        }
    }
}
