package codegym.vn.internmanagement.controller.intern;

import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.model.InternModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller handling searching, filtering, and listing interns for HR.
 * GET /hr/interns?keyword=...&university=...&major=...&status=...
 */
@WebServlet("/hr/interns")
public class InternListServlet extends HttpServlet {

    private InternModel internModel;

    @Override
    public void init() {
        internModel = new InternModel();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String university = request.getParameter("university");
        String major = request.getParameter("major");
        String status = request.getParameter("status");

        List<Intern> interns = internModel.searchInterns(keyword, university, major, status);

        request.setAttribute("interns", interns);
        request.setAttribute("keyword", keyword);
        request.setAttribute("university", university);
        request.setAttribute("major", major);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/WEB-INF/views/intern/list.jsp")
                .forward(request, response);
    }
}
