package codegym.vn.internmanagement.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Evaluation {
    private Long id;
    private Long internId;
    private Long mentorId;
    private BigDecimal technicalScore;
    private BigDecimal attitudeScore;
    private BigDecimal communicationScore;
    private BigDecimal overallScore;
    private String comments;
    private Timestamp evaluatedAt;

    // Joined display fields
    private String internName;
    private String studentCode;
    private String university;
    private String major;
    private String internEmail;
    private String internPhone;
    private String mentorName;
    private String mentorEmail;
    private String department;

    public Evaluation() {
    }

    public Evaluation(Long id, Long internId, Long mentorId, BigDecimal technicalScore,
                      BigDecimal attitudeScore, BigDecimal communicationScore,
                      BigDecimal overallScore, String comments, Timestamp evaluatedAt) {
        this.id = id;
        this.internId = internId;
        this.mentorId = mentorId;
        this.technicalScore = technicalScore;
        this.attitudeScore = attitudeScore;
        this.communicationScore = communicationScore;
        this.overallScore = overallScore;
        this.comments = comments;
        this.evaluatedAt = evaluatedAt;
    }

    public String getGrade() {
        if (overallScore == null) return "Chưa xếp loại";
        double score = overallScore.doubleValue();
        if (score >= 9.0) return "Xuất sắc";
        if (score >= 8.0) return "Giỏi";
        if (score >= 6.5) return "Khá";
        if (score >= 5.0) return "Trung bình";
        return "Chưa đạt";
    }

    public String getGradeBadgeClass() {
        if (overallScore == null) return "badge-pending";
        double score = overallScore.doubleValue();
        if (score >= 9.0) return "badge-approved";
        if (score >= 8.0) return "badge-interning";
        if (score >= 6.5) return "badge-completed";
        if (score >= 5.0) return "badge-pending";
        return "badge-rejected";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getInternId() {
        return internId;
    }

    public void setInternId(Long internId) {
        this.internId = internId;
    }

    public Long getMentorId() {
        return mentorId;
    }

    public void setMentorId(Long mentorId) {
        this.mentorId = mentorId;
    }

    public BigDecimal getTechnicalScore() {
        return technicalScore;
    }

    public void setTechnicalScore(BigDecimal technicalScore) {
        this.technicalScore = technicalScore;
    }

    public BigDecimal getAttitudeScore() {
        return attitudeScore;
    }

    public void setAttitudeScore(BigDecimal attitudeScore) {
        this.attitudeScore = attitudeScore;
    }

    public BigDecimal getCommunicationScore() {
        return communicationScore;
    }

    public void setCommunicationScore(BigDecimal communicationScore) {
        this.communicationScore = communicationScore;
    }

    public BigDecimal getOverallScore() {
        return overallScore;
    }

    public void setOverallScore(BigDecimal overallScore) {
        this.overallScore = overallScore;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getEvaluatedAt() {
        return evaluatedAt;
    }

    public void setEvaluatedAt(Timestamp evaluatedAt) {
        this.evaluatedAt = evaluatedAt;
    }

    public String getInternName() {
        return internName;
    }

    public void setInternName(String internName) {
        this.internName = internName;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getInternEmail() {
        return internEmail;
    }

    public void setInternEmail(String internEmail) {
        this.internEmail = internEmail;
    }

    public String getInternPhone() {
        return internPhone;
    }

    public void setInternPhone(String internPhone) {
        this.internPhone = internPhone;
    }

    public String getMentorName() {
        return mentorName;
    }

    public void setMentorName(String mentorName) {
        this.mentorName = mentorName;
    }

    public String getMentorEmail() {
        return mentorEmail;
    }

    public void setMentorEmail(String mentorEmail) {
        this.mentorEmail = mentorEmail;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }
}
