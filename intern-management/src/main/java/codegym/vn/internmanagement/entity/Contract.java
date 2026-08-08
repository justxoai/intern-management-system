package codegym.vn.internmanagement.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity mapping the 'contracts' table.
 */
public class Contract {
    private Long id;
    private Long internId;
    private Long documentId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;           // PENDING, CONFIRMED, CANCELLED
    private LocalDateTime confirmedAt;

    // Joined display fields
    private String internName;
    private String studentCode;
    private String fileName;
    private String filePath;

    public Contract() {}

    public Long getId()                     { return id; }
    public void setId(Long id)              { this.id = id; }
    public Long getInternId()               { return internId; }
    public void setInternId(Long v)         { this.internId = v; }
    public Long getDocumentId()             { return documentId; }
    public void setDocumentId(Long v)       { this.documentId = v; }
    public LocalDate getStartDate()         { return startDate; }
    public void setStartDate(LocalDate v)   { this.startDate = v; }
    public LocalDate getEndDate()           { return endDate; }
    public void setEndDate(LocalDate v)     { this.endDate = v; }
    public String getStatus()               { return status; }
    public void setStatus(String v)         { this.status = v; }
    public LocalDateTime getConfirmedAt()         { return confirmedAt; }
    public void setConfirmedAt(LocalDateTime v)   { this.confirmedAt = v; }
    public String getInternName()           { return internName; }
    public void setInternName(String v)     { this.internName = v; }
    public String getStudentCode()          { return studentCode; }
    public void setStudentCode(String v)    { this.studentCode = v; }
    public String getFileName()             { return fileName; }
    public void setFileName(String v)       { this.fileName = v; }
    public String getFilePath()             { return filePath; }
    public void setFilePath(String v)       { this.filePath = v; }
}
