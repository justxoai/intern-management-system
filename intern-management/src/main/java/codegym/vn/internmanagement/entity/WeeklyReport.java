package codegym.vn.internmanagement.entity;

import java.sql.Timestamp;

public class WeeklyReport {
    private Long id;
    private Long internId;
    private Long mentorId;
    private Integer weekNumber;
    private String title;
    private String content;
    private Timestamp submittedAt;
    private String feedback;
    private Timestamp reviewedAt;
    private String status;
    private String internName; // for display purposes

    public WeeklyReport() {
    }

    public WeeklyReport(Long id, Long internId, Long mentorId, Integer weekNumber, String title, String content, Timestamp submittedAt, String feedback, Timestamp reviewedAt, String status) {
        this.id = id;
        this.internId = internId;
        this.mentorId = mentorId;
        this.weekNumber = weekNumber;
        this.title = title;
        this.content = content;
        this.submittedAt = submittedAt;
        this.feedback = feedback;
        this.reviewedAt = reviewedAt;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getInternId() { return internId; }
    public void setInternId(Long internId) { this.internId = internId; }
    public Long getMentorId() { return mentorId; }
    public void setMentorId(Long mentorId) { this.mentorId = mentorId; }
    public Integer getWeekNumber() { return weekNumber; }
    public void setWeekNumber(Integer weekNumber) { this.weekNumber = weekNumber; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getInternName() { return internName; }
    public void setInternName(String internName) { this.internName = internName; }
}
