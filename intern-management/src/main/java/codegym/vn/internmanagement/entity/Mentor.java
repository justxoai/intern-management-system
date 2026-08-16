package codegym.vn.internmanagement.entity;

import java.time.LocalDateTime;

/**
 * Entity for the 'mentors' table, enriched with joined user fields
 * and computed intern count.
 */
public class Mentor {
    private Long id;
    private Long userId;

    // Joined from users
    private String fullName;
    private String email;
    private String phone;
    private String userStatus;

    // mentors columns
    private String department;
    private String position;
    private int    maxInterns;
    private int    currentInternCount; // from COUNT(ma.id)

    private LocalDateTime createdAt;

    public Mentor() {}

    public Long getId()                     { return id; }
    public void setId(Long v)               { this.id = v; }
    public Long getUserId()                 { return userId; }
    public void setUserId(Long v)           { this.userId = v; }
    public String getFullName()             { return fullName; }
    public void setFullName(String v)       { this.fullName = v; }
    public String getEmail()                { return email; }
    public void setEmail(String v)          { this.email = v; }
    public String getPhone()                { return phone; }
    public void setPhone(String v)          { this.phone = v; }
    public String getUserStatus()           { return userStatus; }
    public void setUserStatus(String v)     { this.userStatus = v; }
    public String getDepartment()           { return department; }
    public void setDepartment(String v)     { this.department = v; }
    public String getPosition()             { return position; }
    public void setPosition(String v)       { this.position = v; }
    public int getMaxInterns()              { return maxInterns; }
    public void setMaxInterns(int v)        { this.maxInterns = v; }
    public int getCurrentInternCount()      { return currentInternCount; }
    public void setCurrentInternCount(int v){ this.currentInternCount = v; }
    public LocalDateTime getCreatedAt()     { return createdAt; }
    public void setCreatedAt(LocalDateTime v){ this.createdAt = v; }
}
