package codegym.vn.internmanagement.entity;

public class MentorAssignment {
    private Long id;
    private Long mentorId;
    private Long internId;
    private String assignedAt;

    private String mentorName;
    private String internName;
    private String internCode;
    private Integer maxInterns;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getMentorId() {
        return mentorId;
    }

    public void setMentorId(Long mentorId) {
        this.mentorId = mentorId;
    }

    public Long getInternId() {
        return internId;
    }

    public void setInternId(Long internId) {
        this.internId = internId;
    }

    public String getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(String assignedAt) {
        this.assignedAt = assignedAt;
    }

    public String getMentorName() {
        return mentorName;
    }

    public void setMentorName(String mentorName) {
        this.mentorName = mentorName;
    }

    public String getInternName() {
        return internName;
    }

    public void setInternName(String internName) {
        this.internName = internName;
    }

    public String getInternCode() {
        return internCode;
    }

    public void setInternCode(String internCode) {
        this.internCode = internCode;
    }

    public Integer getMaxInterns() {
        return maxInterns;
    }

    public void setMaxInterns(Integer maxInterns) {
        this.maxInterns = maxInterns;
    }
}
