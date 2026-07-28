package codegym.vn.internmanagement.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity representing the 'tasks' table.
 */
public class Task {

    private Long id;
    private String title;
    private String description;
    private Long internId;
    private Long mentorId;
    private String status; // TODO, IN_PROGRESS, DONE
    private LocalDate dueDate;
    private LocalDateTime createdAt;

    // Joined display fields
    private String internName;
    private String mentorName;

    public Task() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getInternId() { return internId; }
    public void setInternId(Long internId) { this.internId = internId; }

    public Long getMentorId() { return mentorId; }
    public void setMentorId(Long mentorId) { this.mentorId = mentorId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getInternName() { return internName; }
    public void setInternName(String internName) { this.internName = internName; }

    public String getMentorName() { return mentorName; }
    public void setMentorName(String mentorName) { this.mentorName = mentorName; }
}
