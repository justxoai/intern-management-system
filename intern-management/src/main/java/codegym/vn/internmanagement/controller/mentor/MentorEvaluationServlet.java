package codegym.vn.internmanagement.controller.mentor;

import codegym.vn.internmanagement.dao.EvaluationDAO;
import codegym.vn.internmanagement.dao.MentorDAO;
import codegym.vn.internmanagement.entity.Evaluation;
import codegym.vn.internmanagement.entity.Intern;
import codegym.vn.internmanagement.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/mentor/evaluations", "/mentor/evaluations/save"})
public class MentorEvaluationServlet extends HttpServlet {

    private EvaluationDAO evaluationDAO;
    private MentorDAO mentorDAO;

    @Override
    public void init() {
        evaluationDAO = new EvaluationDAO();
        mentorDAO = new MentorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long mentorUserId = currentUser.getId();
        List<Intern> allMyInterns = mentorDAO.findInternsByMentorUserId(mentorUserId);
        List<Evaluation> evaluations = evaluationDAO.findByMentorUserId(mentorUserId);

        Map<Long, Evaluation> evalMap = new HashMap<>();
        for (Evaluation e : evaluations) {
            evalMap.put(e.getInternId(), e);
        }

        String editInternIdStr = request.getParameter("internId");
        Evaluation selectedEval = null;
        Intern selectedIntern = null;
        if (editInternIdStr != null && !editInternIdStr.isBlank()) {
            try {
                long iId = Long.parseLong(editInternIdStr.trim());
                selectedEval = evalMap.get(iId);
                selectedIntern = allMyInterns.stream().filter(i -> i.getId() == iId).findFirst().orElse(null);
            } catch (Exception ignored) {}
        }

        int totalInterns = allMyInterns.size();
        int evaluatedCount = 0;
        double sumOverall = 0;
        for (Intern i : allMyInterns) {
            if (evalMap.containsKey(i.getId())) {
                evaluatedCount++;
                Evaluation ev = evalMap.get(i.getId());
                if (ev.getOverallScore() != null) {
                    sumOverall += ev.getOverallScore().doubleValue();
                }
            }
        }
        int unEvaluatedCount = totalInterns - evaluatedCount;
        double avgScore = evaluatedCount > 0 ? Math.round((sumOverall / evaluatedCount) * 10.0) / 10.0 : 0.0;

        request.setAttribute("allMyInterns", allMyInterns);
        request.setAttribute("evaluations", evaluations);
        request.setAttribute("evalMap", evalMap);
        request.setAttribute("selectedEval", selectedEval);
        request.setAttribute("selectedIntern", selectedIntern);
        request.setAttribute("totalInterns", totalInterns);
        request.setAttribute("evaluatedCount", evaluatedCount);
        request.setAttribute("unEvaluatedCount", unEvaluatedCount);
        request.setAttribute("avgScore", avgScore);

        request.getRequestDispatcher("/WEB-INF/views/mentor/evaluations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String internIdStr = request.getParameter("internId");
        String techScoreStr = request.getParameter("technicalScore");
        String attScoreStr = request.getParameter("attitudeScore");
        String commScoreStr = request.getParameter("communicationScore");
        String overallScoreStr = request.getParameter("overallScore");
        String comments = request.getParameter("comments");

        Long internId = null;
        try {
            if (internIdStr != null && !internIdStr.isBlank()) internId = Long.parseLong(internIdStr.trim());
        } catch (Exception ignored) {}

        if (internId == null) {
            response.sendRedirect(request.getContextPath() + "/mentor/evaluations?error=Vui+l%C3%B2ng+ch%E1%BB%8Dn+th%E1%BB%B1c+t%E1%BA%ADp+sinh");
            return;
        }

        BigDecimal techScore = parseScore(techScoreStr);
        BigDecimal attScore = parseScore(attScoreStr);
        BigDecimal commScore = parseScore(commScoreStr);
        BigDecimal overallScore = parseScore(overallScoreStr);

        // Auto compute overall score if not explicitly set
        if (overallScore == null && techScore != null && attScore != null && commScore != null) {
            overallScore = techScore.add(attScore).add(commScore)
                    .divide(new BigDecimal("3"), 2, RoundingMode.HALF_UP);
        }

        Long mentorId = mentorDAO.findMentorIdByUserId(currentUser.getId());
        if (mentorId == null) {
            response.sendRedirect(request.getContextPath() + "/mentor/evaluations?error=Kh%C3%B4ng+t%C3%ACm+th%E1%BA%A5y+th%C3%B4ng+tin+mentor");
            return;
        }

        Evaluation eval = new Evaluation();
        eval.setInternId(internId);
        eval.setMentorId(mentorId);
        eval.setTechnicalScore(techScore);
        eval.setAttitudeScore(attScore);
        eval.setCommunicationScore(commScore);
        eval.setOverallScore(overallScore);
        eval.setComments(comments != null ? comments.trim() : "");

        boolean ok = evaluationDAO.saveOrUpdate(eval);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/mentor/evaluations?success=%C4%90%C3%A3+l%C6%B0u+%C4%91%C3%A1nh+gi%C3%A1+th%E1%BB%B1c+t%E1%BA%ADp+sinh+th%C3%A0nh+c%C3%B4ng");
        } else {
            response.sendRedirect(request.getContextPath() + "/mentor/evaluations?error=Kh%C3%B4ng+th%E1%BB%83+l%C6%B0u+%C4%91%C3%A1nh+gi%C3%A1");
        }
    }

    private BigDecimal parseScore(String str) {
        if (str == null || str.isBlank()) return null;
        try {
            double v = Double.parseDouble(str.trim().replace(',', '.'));
            v = Math.max(0.0, Math.min(10.0, v));
            return BigDecimal.valueOf(v).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception e) {
            return null;
        }
    }
}
