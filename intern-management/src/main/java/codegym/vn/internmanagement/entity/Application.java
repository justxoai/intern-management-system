package codegym.vn.internmanagement.entity;

import java.time.LocalDateTime;

/**
 * Entity for the 'internship_applications' table,
 * enriched with joined intern / user fields.
 */
public class Application {
    private Long id;
    private Long internId;

    // Joined from interns + users
    private String internName;
    private String internEmail;
    private String studentCode;
    private String university;
    private String major;

    private LocalDateTime applicationDate;
    private String status; // PENDING, APPROVED, REJECTED

    private Long reviewedBy;
    private String reviewerName;
    private LocalDateTime reviewedAt;
    private String rejectionReason;

    public Application() {}

    public Long getId()                        { return id; }
    public void setId(Long v)                  { this.id = v; }
    public Long getInternId()                  { return internId; }
    public void setInternId(Long v)            { this.internId = v; }
    public String getInternName()              { return internName; }
    public void setInternName(String v)        { this.internName = v; }
    public String getInternEmail()             { return internEmail; }
    public void setInternEmail(String v)       { this.internEmail = v; }
    public String getStudentCode()             { return studentCode; }
    public void setStudentCode(String v)       { this.studentCode = v; }
    public String getUniversity()              { return university; }
    public void setUniversity(String v)        { this.university = v; }
    public String getMajor()                   { return major; }
    public void setMajor(String v)             { this.major = v; }
    public LocalDateTime getApplicationDate()  { return applicationDate; }
    public void setApplicationDate(LocalDateTime v){ this.applicationDate = v; }
    public String getStatus()                  { return status; }
    public void setStatus(String v)            { this.status = v; }
    public Long getReviewedBy()                { return reviewedBy; }
    public void setReviewedBy(Long v)          { this.reviewedBy = v; }
    public String getReviewerName()            { return reviewerName; }
    public void setReviewerName(String v)      { this.reviewerName = v; }
    public LocalDateTime getReviewedAt()       { return reviewedAt; }
    public void setReviewedAt(LocalDateTime v) { this.reviewedAt = v; }
    public String getRejectionReason()         { return rejectionReason; }
    public void setRejectionReason(String v)   { this.rejectionReason = v; }
}
