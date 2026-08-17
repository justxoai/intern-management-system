package codegym.vn.internmanagement.entity;

import java.sql.Timestamp;

public class InternshipApplication {
    private Long id;
    private Long internId;
    private Timestamp applicationDate;
    private String status;
    private Long reviewedBy;
    private Timestamp reviewedAt;
    private String rejectionReason;

    // Additional fields for display
    private String internName;
    private String reviewerName;

    public InternshipApplication() {
    }

    public InternshipApplication(Long id, Long internId, Timestamp applicationDate, String status, Long reviewedBy, Timestamp reviewedAt, String rejectionReason) {
        this.id = id;
        this.internId = internId;
        this.applicationDate = applicationDate;
        this.status = status;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
        this.rejectionReason = rejectionReason;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getInternId() { return internId; }
    public void setInternId(Long internId) { this.internId = internId; }
    public Timestamp getApplicationDate() { return applicationDate; }
    public void setApplicationDate(Timestamp applicationDate) { this.applicationDate = applicationDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Long getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Long reviewedBy) { this.reviewedBy = reviewedBy; }
    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getInternName() { return internName; }
    public void setInternName(String internName) { this.internName = internName; }
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
}
