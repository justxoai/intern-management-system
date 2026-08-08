package codegym.vn.internmanagement.entity;

import java.time.LocalDateTime;

/**
 * Entity mapping the 'documents' table.
 */
public class Document {

    private Long id;
    private Long internId;
    private String documentType; // CV, INTERNSHIP_APPLICATION, CONTRACT
    private String fileName;
    private String filePath;
    private String status;       // PENDING, APPROVED, REJECTED
    private Long reviewedBy;
    private LocalDateTime reviewedAt;
    private LocalDateTime uploadedAt;

    // Joined display fields
    private String internName;
    private String reviewerName;

    public Document() {}

    public Long getId()                   { return id; }
    public void setId(Long id)            { this.id = id; }

    public Long getInternId()             { return internId; }
    public void setInternId(Long v)       { this.internId = v; }

    public String getDocumentType()       { return documentType; }
    public void setDocumentType(String v) { this.documentType = v; }

    public String getFileName()           { return fileName; }
    public void setFileName(String v)     { this.fileName = v; }

    public String getFilePath()           { return filePath; }
    public void setFilePath(String v)     { this.filePath = v; }

    public String getStatus()             { return status; }
    public void setStatus(String v)       { this.status = v; }

    public Long getReviewedBy()           { return reviewedBy; }
    public void setReviewedBy(Long v)     { this.reviewedBy = v; }

    public LocalDateTime getReviewedAt()          { return reviewedAt; }
    public void setReviewedAt(LocalDateTime v)     { this.reviewedAt = v; }

    public LocalDateTime getUploadedAt()          { return uploadedAt; }
    public void setUploadedAt(LocalDateTime v)     { this.uploadedAt = v; }

    public String getInternName()         { return internName; }
    public void setInternName(String v)   { this.internName = v; }

    public String getReviewerName()       { return reviewerName; }
    public void setReviewerName(String v) { this.reviewerName = v; }
}
